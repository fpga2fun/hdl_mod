#!/tools/open/bin/python3
#-*-coding:UTF-8-*-
import os
import sys
import datetime
import shutil
import queue
import time
import math
import json
import subprocess as sp
import threading as td
from concurrent.futures import ThreadPoolExecutor,as_completed
from optparse        import OptionParser
from Logger          import Logger
from TdlManager      import TdlManager
from ArgManager      import ArgManager
from SeedRegressCtrl import SeedRegressCtrl
from PrePosCompile   import PrePosCompile
from GenFilelist     import GenFilelist
from VcsFlow         import VcsFlow
from SimFlow         import SimFlow
from ReadReport      import ReadReport
from operate_csv_gen  import operate_csv_gen

pre_post_valid_rules = ['__pre_comp__','__pos_comp__']

def json_debug(src):
	with open("debug.json",'w') as fpt:
		json.dump(src,fpt,indent=2,ensure_ascii=False)
	exit(1)

def EnvCheck(log,env_val):
	res = os.getenv(env_val)
	if(res != None):
		if(res.strip()[-1] == '/'):
			res = res.strip()[:-1]
	else:
		log.logger.error('Environment ${%s} Var is None' %env_val)
		exit(1)
	log.logger.info(f'Env Value --- {env_val} : {res}')
	return res

def CmdLineDicts(cmd_line_opts,opts,key,value):
	if(opts == None):
		cmd_line_opts.update({key:None})
	else:
		cmd_line_opts.update({key:value})
	return cmd_line_opts

def GenTdl(func,file_name,src_tdl_dict):
	if(src_tdl_dict == False):
		exit(1)
	else:
		test_value = list(src_tdl_dict.values())[0]
		out_tdl_path = func.CreateJson(test_value['data_base'],file_name,src_tdl_dict)

def DelFile(file_url) :
	if os.path.exists(file_url) == True :
		cmd = 'rm -rf '+file_url
		print(cmd)
		os.system(cmd)

def RunFunction(target,log_dir):
	res = target()
	if(res == False):
		DelFile(log_dir)
	return res

def VersionRecorder(log):
	res = {}
	rtl_dir = EnvCheck(log,'RTL_DIR')
	ver_dir = EnvCheck(log,'VERIFY_DIR')
	if(os.path.exists(rtl_dir) == False):
		log.logger.error(f'RTL_PATH env variable not exists')
		return False
	if(os.path.exists(ver_dir) == False):
		log.logger.error(f'VERIFY_DIR env variable not exists')
		return False
	git_cmd = 'git log -1'
	cmd = f'cd {rtl_dir} && {git_cmd}'
	result = sp.run(cmd,shell=True,capture_output=True,text=True)
	stdout_out = result.stdout.split()
	res.update({'rtl':stdout_out[1]})
	cmd = f'cd {ver_dir} && {git_cmd}'
	result = sp.run(cmd,shell=True,capture_output=True,text=True)
	stdout_out = result.stdout.split()
	res.update({'ver':stdout_out[1]})
	return res

def ListTestName(tdl_dicts):
	case_list = '' 
	keys = list(tdl_dicts.keys())
	for cindx in range(len(keys)):
		spece_str = ''
		spece = 45 - len(keys[cindx])
		if(((cindx+1)%4) == False):
			spece_str = spece_str + '\n'
		else:
			for indx in range(spece):
				spece_str = spece_str + ' '
		case_list = case_list + keys[cindx]+spece_str
	print(case_list)

def JobMon(*args):
	job_trace,total_case_num,log,tracelock = args
	while(True): #check job_trace is not empty
		if(len(job_trace)):
			break
		else:
			time.sleep(0.1)
	finish_case_num = 0
	while(True):
		finish_job_trace = []
		with tracelock:
			keys_list = job_trace.keys()
			for jobid in keys_list:
				cmd = f'bjobs -W {jobid}'
				pc = sp.Popen(cmd,shell=True,stdout=sp.PIPE,stderr=sp.STDOUT)
				returncode = pc.poll()
				while returncode is None:
					res = pc.stdout.readline().decode('utf-8').strip()
					if('DONE' in res or 'EXIT' in res):
						finish_case_num = finish_case_num + job_trace[jobid]
						proc = math.floor(finish_case_num / total_case_num * 100)
						with lock:
							log.logger.info(f'Hold On Please.... Total_Case/Finish_Case : {total_case_num}/{finish_case_num} [{proc}%]'.strip())
						finish_job_trace.append(jobid)
					returncode = pc.poll()
			for jobid in finish_job_trace:
				del job_trace[jobid]
		if(finish_case_num >= total_case_num):
			break
		time.sleep(1)

def ResultMon(*args):
	jobrslt,result_list = args
	while(True): #check jobrslt is not empty
		if(len(jobrslt)):
			break
		else:
			time.sleep(0.1)
	while(len(jobrslt)):
		data = jobrslt[0].stdout.readline()
		data = jobrslt[0].stdout.readline()
		data = jobrslt[0].stdout.readline()
		res = json.loads(data.decode().strip())
		result_list.extend(res)
		jobrslt.pop(0)

def SignalLogJobTr(*args):
	sim_dir_list,log,jobrslt,current_time,report_indx,rsltlock = args
	my_str = json.dumps(sim_dir_list)
	tools_path = os.getenv('TOOLS_HOME')
	if(report_indx == None):
		cmd = f'bsub -I python3 {tools_path}/ReportAnalysis.py -d \'{my_str}\' -t {current_time}'
	else:
 		cmd = f'bsub -I python3 {tools_path}/ReportAnalysis.py -d \'{my_str}\' -rn {report_indx} -t {current_time}'
	pc = sp.Popen(cmd,shell=True,stdout=sp.PIPE,stderr=sp.STDOUT)
	jobid = pc.stdout.readline().decode('utf-8').strip().split()[1][1:-1]
	with rsltlock:
		jobrslt.append(pc)
	return {jobid:len(sim_dir_list)}

def AnalysisRpt(log,cmd_line_opts,src_tdls,log_dir,current_time,slice_size,report_indx,pool):
	if(report_indx != None):
		for k in src_tdls.keys():
			rp = ReadReport(log,cmd_line_opts,k,None,current_time,report_indx)
			fail_rpt_case_dict = rp()
			if(fail_rpt_case_dict == False):
				return False
		return {}
	sim_dir_lists = []
	for v in src_tdls.values():
		for t in v.values():
			if(type(t) == dict):
				sim_dir_lists.append(t['sim_dir'])
	total_case_num = len(sim_dir_lists)
	split_list = []
	split_list = [sim_dir_lists[indx:indx+slice_size] for indx in range(0,len(sim_dir_lists),slice_size)]
	info = f'EACH JOB HANDLES MAX {slice_size} ISSUES'
	slash = ['-' for indx in range(len(info))]
	log.logger.debug(f'{"".join(slash)}')
	log.logger.debug(f'TOTAL CASE : {total_case_num}')
	log.logger.debug(f'NEED SUBMIT : {len(split_list)} JOB')
	log.logger.debug(f'{info}')
	log.logger.debug(f'{"".join(slash)}')
	st = datetime.datetime.now().strftime("%m-%d %H:%M:%S:%f'")
	tr_l        = []
	job_trace   = {}
	jobrslt     = []
	result_list = []
	result_dict = {}
	rsltlock  = td.Lock()
	tracelock = td.Lock()
	try:
		jobmon = pool.submit(JobMon,job_trace,total_case_num,log,tracelock)
		rsltmon= pool.submit(ResultMon,jobrslt,result_list)
		for s in split_list:
			tr = pool.submit(SignalLogJobTr,s,log,jobrslt,current_time,report_indx,rsltlock)
			tr_l.append(tr)
			time.sleep(0.01)
		for future in as_completed(tr_l):
			with tracelock:
				job_trace.update(future.result())
		for future in as_completed([jobmon,rsltmon]):
			None
		result_dict.update({key.split('/')[-1]:[] for key in src_tdls.keys()})
		for result in result_list:
			result_dict[result['db']].extend([result])
	except:
		log.logger.error(f'---------------------------------------')
		log.logger.error(f'Terminal Err Interrupt And Kill ALL Job')
		log.logger.error(f'---------------------------------------')
		for jobid in job_trace:
			pc = sp.Popen(f'bkill {jobid}',shell=True,stdout=sp.PIPE)
		DelFile(log_dir)
		exit()
	#json_dubug_dump(result_dict)
	#with open ('debug.json','r') as fp:
	#	result_dict = json.load(fp)
	rp = ReadReport(log,cmd_line_opts,None,result_dict,current_time,report_indx=None)
	fail_rpt_case_dict = rp()
	if(cmd_line_opts['opc'] == True):
		op_csv_gen = operate_csv_gen(cmd_line_opts,None,result_dict,current_time)
		op_csv_gen()
	if(cmd_line_opts['rf'] != True):
		ed = datetime.datetime.now().strftime("%m-%d %H:%M:%S:%f'")
		log.logger.debug('')
		log.logger.debug(f'Log Trace Performance st = {st} ------ ed = {ed}')
		log.logger.debug('')
	return fail_rpt_case_dict

def SimOneCase(*args):
	log,log_dir,test_values,cmd_line_opts,current_time,total_case_num,sync_info,pool,total_case_num,finish_case_num = args
	data_base_name = test_values['data_base'].split('/')[-1]
	sf = SimFlow(log,test_values,cmd_line_opts,current_time,sync_info)
	#log.logger.info('Data_Base/Case_Name : %s/%s Running : Total_Case = %d' %(data_base_name,test_values['test_name'],total_case_num))
	rlst = RunFunction(sf,log_dir)
	if(rlst == False):
		return False
	finish_case_num[0] = finish_case_num[0] + 1
	proc = math.floor(finish_case_num[0] / total_case_num * 100)
	if(rlst['status'].strip() == 'PASS'):
		log.logger.info('%s/%s Total_Case/Finish_Case(%s) : %d/%d [%d%%]' %(test_values['data_base'].split('/')[-1],rlst['name'].strip(),rlst['status'].strip(),total_case_num,finish_case_num[0],proc))
	else:
		log.logger.error('%s/%s Total_Case/Finish_Case(%s) : %d/%d [%d%%]' %(test_values['data_base'].split('/')[-1],rlst['name'].strip(),rlst['status'].strip(),total_case_num,finish_case_num[0],proc))
	return rlst

def SimOneDatabase(*args):
	log,log_dir,data_base_key,data_base_values,comp_def_extract,cmd_line_opts,current_time,result_dict,lock,sync_info,pool = args
	db_key = data_base_key.split('/')[-1]
	with lock:
		result_dict.update({db_key:[]})
	ppc = PrePosCompile(log,None,data_base_key,data_base_values,cmd_line_opts)
	ppc_out_tdl_dict = RunFunction(ppc,log_dir)
	if(ppc_out_tdl_dict == False):
		return False
	gf = GenFilelist(log,file_list_path,file_list,'','',ppc_out_tdl_dict,'',comp_def_extract,cmd_line_opts)
	if(RunFunction(gf,log_dir) == False):
		exit(1)
	if(cmd_line_opts['fo'] == True):
		return True
	vf = VcsFlow(log,data_base_values,cmd_line_opts,current_time,sync_info)
	if(RunFunction(vf,log_dir) == False):
		return False
	ppc = PrePosCompile(log,None,data_base_key,data_base_values,cmd_line_opts,True)
	if(RunFunction(ppc,log_dir) == False):
		return False
	task_list = []
	finish_case_num = [0];
	if(cmd_line_opts['ns'] == None):
		total_case_num = len(list(data_base_values.values())) - 2
		#data_base_name = list(data_base_values.values())[0]['data_base'].split('/')[-1]
	#try:
		log.logger.info('Data_Base : %s running,total case num : %d ! Hold on please.......' %(data_base_key,total_case_num))
		for test_values in data_base_values.values():
			if(type(test_values) == dict):
				task = pool.submit(SimOneCase,log,log_dir,test_values,cmd_line_opts,current_time,total_case_num,sync_info,pool,total_case_num,finish_case_num)
				task_list.append(task)
				if('ZEBU_SERVER' in os.environ):
					time.sleep(0.1)
				else:
					time.sleep(0.05)
		for future in as_completed(task_list):
			rlst = future.result()
			result_dict[db_key].append(rlst)
	#except:
	#	log.logger.error('Simulation : Unexpect Interrupt Occur!')
		info = f'DataBase({db_key}) Finish Sim'
		slash = ['-' for indx in range(len(info))]
		log.logger.debug(''.join(slash))
		log.logger.debug(info)
		log.logger.debug(''.join(slash))
	else:
		log.logger.debug('------------------------')
		log.logger.debug('[Flow] Bypass Simulation')
		log.logger.debug('------------------------')
	return True

if __name__ == '__main__':

	parser = OptionParser();
	parser.add_option('-f'    ,'--file_list'        ,action='store'     ,type='string',dest='file_list'        ,help='Specify filelist for compile')
	parser.add_option('--fo'  ,'--filelist_gen'     ,action='store_true'              ,dest='filelist_gen'     ,help='Only generate filelist')
	parser.add_option('--psf' ,'--pre_script_file'  ,action='store'     ,type='string',dest='pre_script_file'  ,help='Specify script file with shell cmd before xrun')
	parser.add_option('--ps'  ,'--pre_script'       ,action='store'     ,type='string',dest='pre_script'       ,help='Specify shell cmd before xrun')
	parser.add_option('-t'    ,'--tdl_names'        ,action='store'     ,type='string',dest='tdl_names'        ,help='Specify tdl file')
	parser.add_option('-n'    ,'--test_names'       ,action='store'     ,type='string',dest='test_names'       ,help='Specify test case tdl path or file')
	parser.add_option('--ln'  ,'--list_test_names'  ,action='store_true'              ,dest='list_test_names'  ,help='List all case name')
	parser.add_option('-p'    ,'--max_parallel'     ,action='store'     ,type='int'   ,dest='max_parallel'     ,help='Specify max parallel degree for simulation,defaule degree is 256')
	parser.add_option('-r'    ,'--lsf_mem_size'     ,action='store'     ,type='string',dest='lsf_mem_size'     ,help='Specify lsf max mem size')
	parser.add_option('-q'    ,'--lsf_queue'        ,action='store'     ,type='string',dest='lsf_queue'        ,help='Specify lsf queue')
	parser.add_option('-m'    ,'--lsf_job_host'     ,action='store'     ,type='string',dest='lsf_job_host'     ,help='Specify lsf job host for excute')
	parser.add_option('--dl'  ,'--lsf_bypass'       ,action='store_true'              ,dest='lsf_bypass'       ,help='Disable lsf cmd')
	parser.add_option('--vho' ,'--vhdl_opts'        ,action='store'     ,type='string',dest='vhdl_opts'        ,help='Specify vhdl opts for compile')
	parser.add_option('--vlo' ,'--vlog_opts'        ,action='store'     ,type='string',dest='vlog_opts'        ,help='Specify vlog opts for compile')
	parser.add_option('--vco' ,'--vcs_opts'         ,action='store'     ,type='string',dest='vcs_opts'         ,help='Specify vcs opts for compile')
	parser.add_option('--sio' ,'--sim_opts'         ,action='store'     ,type='string',dest='sim_opts'         ,help='Specify sim opts for simulation')
	parser.add_option('-o'    ,'--db_root_dir'      ,action='store'     ,type='string',dest='db_root_dir'      ,help='Specify data base root path')
	parser.add_option('-c'    ,'--rm_compile_folder',action='store_true'              ,dest='rm_compile_folder',help='Delete compile folder and ignore -bv')
	parser.add_option('--cs'  ,'--rm_sim_folder'    ,action='store_true'              ,dest='rm_sim_folder'    ,help='Delete sim folder')
	parser.add_option('--cov' ,'--coverage'         ,action='store'     ,type='string',dest='coverage'         ,help='Enable coverage and specify coverage database')
	parser.add_option('--ls'  ,'--last_seed'        ,action='store_true'              ,dest='last_seed'        ,help='Use last sim seed if no define -s arg')
	parser.add_option('-s'    ,'--seed'             ,action='store'     ,type='string',dest='seed'             ,help='Specify sim seed if no arg --ls')
	parser.add_option('--rt'  ,'--regress_times'    ,action='store'     ,type='string',dest='regress_times'    ,help='Specify times for simulation')
	parser.add_option('--sf'  ,'--seed_suffix'      ,action='store_true',              dest='seed_suffix'      ,help='Force the regression folder name to be seed suffix instead of ordinal suffix')
	parser.add_option('-w'    ,'--wave_en'          ,action='store_true'              ,dest='wave_en'          ,help='Enable dump wave')
	parser.add_option('--wf'  ,'--wave_force'       ,action='store_true'              ,dest='wave_force'       ,help='Force dump wave for all parallel sim')
	parser.add_option('--sr'  ,'--stop_rerun'       ,action='store_true'              ,dest='stop_rerun'       ,help='Disable rerun with wave after sim failure')
	parser.add_option('--rf'  ,'--rerun_fail_case'  ,action='store_true'              ,dest='rerun_fail_case'  ,help='Rerun fail case after log analysis without --al')
	parser.add_option('--st'  ,'--start_time'       ,action='store'     ,type='string',dest='start_time'       ,help='Specify start time to dump wave')
	parser.add_option('--et'  ,'--end_time'         ,action='store'     ,type='string',dest='end_time'         ,help='Specify end time to dump wave')
	parser.add_option('--so'  ,'--sim_only'         ,action='store_true'              ,dest='sim_only'         ,help='Bypass vcs compile to simulate dirictly')
	parser.add_option('--ns'  ,'--no_sim'           ,action='store_true'              ,dest='no_sim'           ,help='Bypass vcs simulation for vcs compile only')
	parser.add_option('--al'  ,'--analysis_log'     ,action='store_true'              ,dest='analysis_log'     ,help='Only analysis log in list and ignore --rf')
	parser.add_option('--tar' ,'--decompress'       ,action='store_true'              ,dest='decompress'       ,help='Decompress file with .tar .gz or zip in sim path')
	parser.add_option('--rn'  ,'--report_indx'      ,action='store'     ,type='int'   ,dest='report_indx'      ,help='Specify the index of the previous report')
	parser.add_option('--fd'  ,'--filelist_def'     ,action='store'     ,type='string',dest='filelist_def'     ,help='Specify filelist define for compile')
	parser.add_option('--td'  ,'--tdl_def'          ,action='store'     ,type='string',dest='tdl_def'          ,help='Specify TDL define for test description')
	parser.add_option('--zs'  ,'--zebu_sim'         ,action='store_true'              ,dest='zebu_sim'         ,help='Zebu vcs compile and sim')
	parser.add_option('--lgn' ,'--log_name'         ,action='store'     ,type='string',dest='log_name'         ,help='Specify xrun trace log name suffix')
	parser.add_option('--opc' ,'--op_csv_gen'       ,action='store_true'              ,dest='op_csv_gen'       ,help='Get operate consuming_time/estimated_time,gen csv file')
	(opts,args) = parser.parse_args()

	if(opts.analysis_log != None):
		opts.max_parallel = 256

	if('ZEBU_SERVER' in os.environ):
		opts.lsf_bypass = True
		if(opts.tdl_def == None):
			opts.tdl_def = 'ZEBU'
		else:
			opts.tdl_def = opts.tdl_def + ' ZEBU'
		if(opts.wave_en != None):
			opts.tdl_def = opts.tdl_def + ' WAVE'
		if(opts.analysis_log != None or opts.rerun_fail_case != None):
			opts.max_parallel = 3
		else:
			opts.max_parallel = 2
		opts.stop_rerun = True
		opts.lsf_bypass = True

	cmd_line_opts = {}
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.filelist_gen      ,'fo' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.wave_en           ,'ln' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.lsf_mem_size      ,'r'  ,opts.lsf_mem_size      )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.lsf_queue         ,'q'  ,opts.lsf_queue         )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.lsf_job_host      ,'m'  ,opts.lsf_job_host      )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.lsf_bypass        ,'dl' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.rm_compile_folder ,'c'  ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.rm_sim_folder     ,'cs' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.coverage          ,'cov',opts.coverage          )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.db_root_dir       ,'o'  ,opts.db_root_dir       )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.last_seed         ,'ls' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.seed              ,'s'  ,opts.seed              )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.regress_times     ,'rt' ,opts.regress_times     )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.seed_suffix       ,'sf' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.wave_en           ,'w'  ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.wave_force        ,'wf' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.stop_rerun        ,'sr' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.rerun_fail_case   ,'rf' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.start_time        ,'st' ,opts.start_time        )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.end_time          ,'et' ,opts.end_time          )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.sim_only          ,'so' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.no_sim            ,'ns' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.decompress        ,'tar',True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.report_indx       ,'rn' ,opts.report_indx       )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.analysis_log      ,'al' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.zebu_sim          ,'zs' ,True                   )
	cmd_line_opts = CmdLineDicts(cmd_line_opts,None                   ,'cpt',True                   )   #compile busb -K(cpt=true) or -Is(cpt=none) select
	cmd_line_opts = CmdLineDicts(cmd_line_opts,None                   ,'spt',True                   )	#simulation busb -K(spt=true) or -Is(spt=none) select
	cmd_line_opts = CmdLineDicts(cmd_line_opts,None                   ,'rp' ,True                   )   #relative path for filelist
	cmd_line_opts = CmdLineDicts(cmd_line_opts,opts.op_csv_gen        ,'opc',True                   )   

	current_time = datetime.datetime.now().strftime('%Y%m%d_%H%M%S_%f')
	trace_log_name = 'xrun'+current_time+'.log' if opts.log_name == None else 'xrun_'+opts.log_name+'.log'
	log_dir = os.getcwd()+'/'+trace_log_name
	log = Logger(trace_log_name,'w+',level='debug')

	base_run_path  = EnvCheck(log,'OUTPUT_DIR')
	tdl_base_path  = EnvCheck(log,'TEST_DIR')
	file_list_path = EnvCheck(log,'FILELIST_DIR')
	rtl_dir        = EnvCheck(log,'RTL_DIR')
	ver = VersionRecorder(log)
	if(ver == False):
		DelFile(log_dir)
		exit(1)
	cmd_line_opts.update(ver)

	if(opts.pre_script_file != None):
		script_dir = os.getenv('SCRIPT_PATH').strip()
		if(script_dir.split('/')[-1] != '/'):
			script_dir = script_dir + '/'
		with open(script_dir+opts.pre_script_file,'r') as fpt:
			script_lists = fpt.readlines()
		for atom in script_lists:
			log.logger.info('Preceding xrun sctipt : %s' %(atom))
			if(os.system(atom)):
				log.logger.error('Preceding xrun sctipt is error:')
				log.logger.error('Error script : %s' %(atom))
				exit(1)
	
	if(opts.pre_script != None):
		if(os.system(opts.pre_script.strip())):
			log.logger.error('Preceding xrun sctipt is error:')
			log.logger.error('Error script : %s' %(opts.pre_script.strip()))
			exit(1)

	if(cmd_line_opts['cov'] != None):
		cmd_line_opts['cov'] = cmd_line_opts['cov'] + '/'

	if(opts.file_list == None):
		file_list = 'asic.f'
	else:
		file_list = opts.file_list

	if(opts.max_parallel == None):
		max_parallel = 256
	else:
		if(opts.max_parallel > 1500):
			log.logger.error('-p must be less than 1500')
			DelFile(log_dir)
		max_parallel = opts.max_parallel
	log.logger.info('Mux parallel degree is %d' %max_parallel)

	#TDL Handle
	tm = TdlManager(log,tdl_base_path,opts.tdl_names,opts.test_names,opts.vhdl_opts,opts.vlog_opts,opts.vcs_opts,opts.sim_opts,opts.filelist_def,opts.tdl_def,cmd_line_opts)
	tm_out_tdl_dicts = RunFunction(tm,log_dir)
	if(tm_out_tdl_dicts == False):
		exit(1)
	if(opts.list_test_names):
		ListTestName(tm_out_tdl_dicts)
		DelFile(log_dir)
		exit(1)
	ast = ArgManager(log,None,tm_out_tdl_dicts,base_run_path,opts.db_root_dir,cmd_line_opts)
	ast_out_tdl_dicts = RunFunction(ast,log_dir)
	if(ast_out_tdl_dicts == False):
		exit(1)
	comp_def_extract = ast.get_comp_def()
	src = SeedRegressCtrl(log,None,ast_out_tdl_dicts,opts.test_names,cmd_line_opts)
	src_out_tdl_dicts = RunFunction(src,log_dir)
	if(src_out_tdl_dicts == False):
		exit(1)

	#Log Report and Rerun Fail Case
	pool = ThreadPoolExecutor(max_workers=max_parallel)
	sync_info = queue.Queue()
	lock = td.Lock()
	slice_size = 150
	if(opts.analysis_log != None or opts.report_indx != None):
		log.logger.info('Report Log Analysis!')
		cmd_line_opts['rf'] = None
		fail_rpt_case_dict = AnalysisRpt(log,cmd_line_opts,src_out_tdl_dicts,log_dir,current_time,slice_size,opts.report_indx,pool)
		if(fail_rpt_case_dict == False):
			exit()
		DelFile(log_dir)
		exit()
	elif(opts.rerun_fail_case != None):
		fail_rpt_case_dict = AnalysisRpt(log,cmd_line_opts,src_out_tdl_dicts,log_dir,current_time,slice_size,opts.report_indx,pool)
		if(fail_rpt_case_dict == False):
			exit()
		dst_out_tdl_dicts = {}
		fail_case_number = {}
		for db in fail_rpt_case_dict:
			db_f = f'{os.getenv("OUTPUT_DIR")}/{db}'
			db_case_num = len(fail_rpt_case_dict[db])
			if(db_case_num):
				fail_case_number.update({db:db_case_num})
				dst_out_tdl_dicts.update({db_f:{}})
				for case_name in fail_rpt_case_dict[db]:
					dst_out_tdl_dicts[db_f].update({case_name:src_out_tdl_dicts[db_f][case_name]})
					#log.logger.debug('Data_base/Fail_case_name : %s/%s need rerun' %(db.split('/')[-1],case_name))
				dst_out_tdl_dicts[db_f].update({'__pre_comp__':src_out_tdl_dicts[db_f]['__pre_comp__']})
				dst_out_tdl_dicts[db_f].update({'__pos_comp__':src_out_tdl_dicts[db_f]['__pos_comp__']})
		src_out_tdl_dicts = dst_out_tdl_dicts
		cmd_line_opts['rf'] = None
		opts.analysis_log = True
		for db in fail_case_number:
			if(fail_case_number[db]):
				string = f'Data_base : {db.split("/")[-1]} fail {fail_case_number[db]} cases'
				slash = ['-' for indx in range(len(string))]
				log.logger.debug(''.join(slash))
				log.logger.debug(string)
				log.logger.debug(''.join(slash))
		if('ZEBU_SERVER' in os.environ):
			pool = ThreadPoolExecutor(max_workers=2)

	##Compile Sim
	task_list   = []
	result_dict = {}
	stop_flow   = False
	#json_dubug_dump(src_out_tdl_dicts)
	try:
		for data_base_key,data_base_values in src_out_tdl_dicts.items():
			task = pool.submit(SimOneDatabase,log,log_dir,data_base_key,data_base_values,comp_def_extract,cmd_line_opts,current_time,result_dict,lock,sync_info,pool)
			#task.setDaemon(True)
			task_list.append(task)
			time.sleep(0.3)
		for future in as_completed(task_list):
			rslt = future.result()
			if(rslt == False):
				stop_flow = True
			#else:
			#	result_dict.update(rslt)
		if(cmd_line_opts['ns'] == False):
			log.logger.info('')
			log.logger.info('')
			log.logger.info('--------Finish ALL CASE---------')
			log.logger.info('')
			log.logger.info('')
	except:
		log.logger.error('Database : Unexpect Interrupt Occur! Please wait for job recovery!')
		sync_info.put(['terminte'],block=True,timeout=None)
		for future in task_list:
			future.cancel()

	#Only Gen Filelist
	if(opts.filelist_gen != None):
		log.logger.info('Only Generate filelist!')
		DelFile(log_dir)
		exit()
	
	#print report
	if(cmd_line_opts['ns'] == None):
		rp = ReadReport(log,cmd_line_opts,None,result_dict,current_time,report_indx=None)
		fail_rpt_case_dict = rp()
		if(cmd_line_opts['opc']):
			op_csv_gen = operate_csv_gen(cmd_line_opts,None,result_dict,current_time)
			op_csv_gen()

	#merg coverage
	if(cmd_line_opts['cov'] != None and stop_flow == False):
		cmd = 'bsub -I urg -full64 -log report.log -dir *.vdb -format both -dbname merged -parallel -parallel_split 50 -lsf "-q normal" -sub bsub -del bkill'
		for data_base_key in src_out_tdl_dicts.keys():
			cov_dir = data_base_key+'/../coverage/'+cmd_line_opts['cov']
			cmd = f'bsub -I -cwd {cov_dir} urg -full64 -log report.log -dir *.vdb -format both -dbname merged -parallel -parallel_split 50 -lsf "-q normal" -sub bsub -del bkill'
			log.logger.info('Coverage Path : %s' %(cov_dir))
			log.logger.info('Cm_dir : %s Coverage merge begin' %(cmd_line_opts['cov'][:-1]))
			log.logger.info('Gen Makfile')
			with open(f'{cov_dir}makefile','w') as fp:
				fp.write('verdi:\n\tbsub -Is -q verdi verdi -cov -covdir merged.vdb &\nfx:\n\tfirefox urgReport/hierarchy.html &')
			if(os.path.exists(cov_dir+'/urgReport') == True):
				try:
					log.logger.info('Rm urgReport')
					shutil.rmtree(cov_dir+'/urgReport')
				except:
					log.logger.error('Rm urgReport Fail!')
			if(os.path.exists(cov_dir+'/merged.vdb') == True):
				try:
					log.logger.info('Rm merged.vdb')
					shutil.rmtree(cov_dir+'/merged.vdb')
				except:
					log.logger.error('Rm merged.vdb Fail!')
			log.logger.info('Coverage Cmd : %s' %(cmd))
			os.system(cmd)
			break

	DelFile(log_dir)
	exit()
