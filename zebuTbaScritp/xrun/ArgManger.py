#!/tools/open/bin/python3
#-*-coding:UTF-8-*-
from optparse import OptionParser
import os 
import re
import json
from Logger import Logger

class ArgManager(object) :

	'Argument Sort'

	opts_valid_rules                 = ['+vhdl_opts','+vlog_opts','+vcs_opts','+sim_opts','+pre_comp','+pos_comp','+pre_sim','+data_base','+seed','+rt','+fdef','+dummy_log']
	opts_str_valid_rules             = ['+vhdl_opts','+vlog_opts','+vcs_opts','+sim_opts','+data_base','+seed','+rt','+fdef','+dummy_log']
	opts_pre_cmd_rules               = ['+pre_comp','+pos_comp','+pre_sim']
	opts_def_sort_rules              = ['vhdl_opts','vlog_opts','vcs_opts']
	opts_first_valid_rules           = ['data_base','seed','rt']
	opts_check_data_base_valid_rules = ['vhdl_opts','vlog_opts','vcs_opts','data_base','fdef']
	pre_post_valid_rules             = ['__pre_comp__','__pos_comp__']
	comp_def_extract                 = []

	def __init__(self,log,src_tdl_path,src_tdl_dicts,base_run_path,db_root_dir,cmd_line_opts):
		self.log           = log
		self.src_tdl_path  = src_tdl_path
		self.src_tdl_dicts = src_tdl_dicts
		self.base_run_path = base_run_path
		self.db_root_dir   = db_root_dir
		self.cmd_line_opts = cmd_line_opts
		self.def_out_file  = []

	def json_dubug_dump(self,file_url,src):
		with open(file_url,'w') as fpt:
			json.dump(src,fpt,indent=2,ensure_ascii=False)

	def GetSrcTdlDict(self,src_tdl_path,src_tdl_dicts):
		if(src_tdl_path == None):
			self.log.logger.info('Get Src Tdl Dict')
			return src_tdl_dicts
		else:
			with open(src_tdl_path,'r') as fp:
				json_src_tdl_dicts = json.load(fp)
			return json_src_tdl_dicts

	def AddSimAndCompFolder(self,src_tdl_dicts):
		self.log.logger.info('Create Sim Folder Description')
		for test_name in src_tdl_dicts:
			if(test_name not in ArgManager.pre_post_valid_rules):
				src_tdl_dicts[test_name].update({"sim_dir":src_tdl_dicts[test_name]['data_base']+'/sim/'+test_name})
				src_tdl_dicts[test_name].update({"comp_dir":src_tdl_dicts[test_name]['data_base']+'/compile'})
		return src_tdl_dicts
	
	def SortStrOpts(self,src):
		src_lists = src.strip().split()
		return[src_lists[0],' '.join(src_lists[1:]).strip()]
	
	def SortlistOpts(self,src):
		dst_list = []
		for atom in src:
			rlst = atom.strip().split()
			dst_list.append(' '.join(rlst[1:]).strip())
		return {rlst[0][1:]:dst_list}

	def DefSplit(self,src_lists):
		no_def_lists = []
		for atom in src_lists:
			if('+define+' not in atom):
				no_def_lists.append(atom)
		src_str = ' '.join(src_lists)
		patern = re.compile(r'('+'\+define\+)([a-zA-Z0-9_#\\\/"\'$().{}+=-]+)')
		define_option = patern.findall(src_str)
		def_lists = []
		for atom in define_option :
			def_lists = def_lists + atom[1].strip().split('+')
		rst_def_lists = []
		for atom in def_lists :
			rst_def_lists.append('+define+'+atom)
			if('=' in atom):
				atom = atom.replace('=',' ')
			self.def_out_file.append('`define '+atom)
		dst_list = no_def_lists+rst_def_lists
		return dst_list

	def ReorganizeList(self,opts,src_lists):
		if(len(src_lists) == 0):
			return {opts:src_lists}
		if(opts in ArgManager.opts_def_sort_rules):
			sort_def_lists = self.DefSplit(src_lists)
			deoverlap_list = list(set(sort_def_lists))
			deoverlap_list.sort(key=sort_def_lists.index)
			return {opts:deoverlap_list}
		elif(opts in ArgManager.opts_first_valid_rules):
			return {opts:src_lists[0]}
		else:
			return {opts:src_lists}
		
	def SortEachTdl(self,src_tdl_dicts,db_root_dir):
		self.log.logger.info('Sort Each Tdl Description')
		if(db_root_dir == None):
			db_root_dir = '/'
		else:
			db_root_dir = db_root_dir.strip().strip('/')
			db_root_dir = '/'+db_root_dir+'/'
		for opts in ArgManager.pre_post_valid_rules:
			src_tdl_dicts.update({opts:{}})
		for test_name in src_tdl_dicts:
			if(test_name is not '__pre_comp__' and test_name is not '__pos_comp__'):
				for opts in ArgManager.opts_valid_rules:
					src_tdl_dicts[test_name].update({opts[1:]:[]})
				comp_sim_details = src_tdl_dicts[test_name]['description']
				del src_tdl_dicts[test_name]['description']
				for comp_sim_detail in comp_sim_details:
					if(type(comp_sim_detail) == str):
						rlst = self.SortStrOpts(comp_sim_detail)
						src_tdl_dicts[test_name][rlst[0][1:]].append(rlst[1])
					elif(type(comp_sim_detail) == list):
						rlst = self.SortlistOpts(comp_sim_detail)
						for key,value in rlst.items():
							src_tdl_dicts[test_name][key].append(value)
				for opts in ArgManager.opts_def_sort_rules:
					src_tdl_dicts[test_name].update(self.ReorganizeList(opts,src_tdl_dicts[test_name][opts]))
				for opts in ArgManager.opts_first_valid_rules:
					src_tdl_dicts[test_name].update(self.ReorganizeList(opts,src_tdl_dicts[test_name][opts]))
				if(src_tdl_dicts[test_name]['data_base'] == None or len(src_tdl_dicts[test_name]['data_base']) == 0):
					self.log.logger.error('%s : %s Syntax Error. Has no +data_base args' %(src_tdl_dicts[test_name]['file_url'],test_name))
					return False
				else:
					src_tdl_dicts[test_name]['data_base'] = self.base_run_path+db_root_dir+src_tdl_dicts[test_name]['data_base']
				#for opts in ArgManager.pre_post_valid_rules:
				#	if(src_tdl_dicts[test_name]['data_base'] in src_tdl_dicts[opts].keys()):
				#		for atom in src_tdl_dicts[test_name][opts[2:-2]]:
				#			if(atom not in src_tdl_dicts[opts][src_tdl_dicts[test_name]['data_base']]):
				#				src_tdl_dicts[opts][src_tdl_dicts[test_name]['data_base']].append(atom)
				#	else:
				#		src_tdl_dicts[opts].update({src_tdl_dicts[test_name]['data_base']:src_tdl_dicts[test_name][opts[2:-2]]})
		return src_tdl_dicts

	def TdlGroupSplit(self,src_tdl_dicts):
		self.log.logger.info('Create Compile Group Tdl Description')
		dst_tdl_dicts   = {}
		for tdl_dict in src_tdl_dicts:
			if(tdl_dict not in ArgManager.pre_post_valid_rules):
				if(src_tdl_dicts[tdl_dict]['data_base'] in dst_tdl_dicts.keys()):
					dst_tdl_dicts[src_tdl_dicts[tdl_dict]['data_base']].update({tdl_dict:src_tdl_dicts[tdl_dict]})
				else:
					dst_tdl_dicts.update({src_tdl_dicts[tdl_dict]['data_base']:{tdl_dict:src_tdl_dicts[tdl_dict]}})
			else:
				for data_base in src_tdl_dicts[tdl_dict]:
					dst_tdl_dicts[data_base].update({tdl_dict:src_tdl_dicts[tdl_dict][data_base]})
		for data_base_value in dst_tdl_dicts.values() :
			check_opts_dicts = dict(zip(ArgManager.opts_check_data_base_valid_rules,[[],[],[],[],[]]))
			for test_name in data_base_value:
				if(test_name not in ArgManager.pre_post_valid_rules):
					for args_key,args_value in data_base_value[test_name].items():
						if(args_key in ArgManager.opts_check_data_base_valid_rules):
							check_opts_dicts[args_key].append(' '.join(args_value))
			for opts_key,opts_values in check_opts_dicts.items():
				lis = []
				lis = list(set(opts_values))
				url_dis_lists = []
				db_dis_lists  = ''
				if(len(lis) > 1):
					for test_value in data_base_value.values():
						url_dis_lists.append(test_value['file_url'])
						db_dis_lists = test_value['data_base'].split('/')[-1]
					url_dis_lists = list(set(url_dis_lists))
					for indx in range(0,len(url_dis_lists)):
						self.log.logger.error('%s : [data_base:%s -> %s not same ]' %(url_dis_lists[indx],db_dis_lists,opts_key))
					for indx in range(0,len(lis)) :
						self.log.logger.error('Different %s (indx=%d) %s' %(opts_key,indx,lis[indx]))
					return False
		return dst_tdl_dicts

	def get_comp_def(self):
		return ArgManager.comp_def_extract

	def display(self,dicts):
		for dict_atom in dicts :
			print('%s ' % dict_atom)
			print(dicts[dict_atom])

	def __call__(self):
		src_tdl_dicts = self.GetSrcTdlDict(self.src_tdl_path,self.src_tdl_dicts)
		if(src_tdl_dicts == None):
			return False
		result_opts_tdl_dicts = self.SortEachTdl(src_tdl_dicts,self.db_root_dir)
		if(result_opts_tdl_dicts == False):
			return False
		src_tdl_dicts = self.AddSimAndCompFolder(result_opts_tdl_dicts)
		if(result_opts_tdl_dicts == False):
			return False
		grop_tdl_dicts = self.TdlGroupSplit(result_opts_tdl_dicts)
		ArgManager.comp_def_extract = list(set(self.def_out_file))
		ArgManager.comp_def_extract.sort(key=self.def_out_file.index)
		return grop_tdl_dicts
		
	def CreateJson(self,file_dir,file_name,src_dict):
		if(file_dir == None):
			file_dir = '.'
		if(file_name == None):
			file_name = 'test_tdl.tdl'
		out_file_path = file_dir+'/'+file_name
		fp = open(out_file_path,'w')
		json.dump(src_dict,fp,indent=2,ensure_ascii=False)
		fp.close()
		self.log.logger.info('Success Create Final Tdl : %s' %os.path.abspath(out_file_path))
		return os.path.abspath(out_file_path)

if __name__ == '__main__' :

	parser = OptionParser();
	parser.add_option("-f","--src_tdl_path",action="store",type="string",dest="src_tdl_path",help="Specify tdl src file")
	parser.add_option("-o","--out_tdl_path",action="store",type="string",dest="out_tdl_path",help="Specify out tdl file")
	parser.add_option("-r","--base_run_path",action="store",type="string",dest="base_run_path",help="Specify base run path")
	(options,args) = parser.parse_args()
	
	src_tdl_path  = options.src_tdl_path
	out_tdl_path  = options.out_tdl_path
	base_run_path = options.base_run_path

	log = Logger('ArgManager.log','w+',level='info')
	ast = ArgManager(log,src_tdl_path,src_tdl_dicts,base_run_path)
	out_tdl_dict = ast()
	if(out_tdl_dict == False):
		exit()
	else :
		out_tdl_path = ast.CreateJson(None,None,out_tdl_dict)

