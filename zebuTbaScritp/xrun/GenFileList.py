#!/tools/open/bin/python3
#-*-coding:UTF-8-*-
from optparse import OptionParser
import os
import sys
import json
import re
import filecmp
from Logger import Logger
from DefContentEx import DefContentEx

class GenFilelist(object) :

	'Extract file list to compile cmd_line_opts{}'

	def __init__(self,log,src_folder='',filelists='',case_paths='',output_folder='',src_tdl_dicts={},define='',comp_def_extract=[],cmd_line_opts={'rp':None}) :
		self.log               = log
		self.src_folder        = src_folder
		self.filelists         = filelists
		self.case_paths        = case_paths
		self.output_folder     = output_folder
		self.src_tdl_dicts     = src_tdl_dicts
		self.fdefine_lists     = define.strip().split()
		self.comp_def_extract  = comp_def_extract
		self.cmd_line_opts     = cmd_line_opts
		self.run_path          =  ''
		self.case_path         =  ''
		self.incdir_list       = []
		self.y_list            = []
		self.v_list            = []
		self.content_vhdl_list = []
		self.content_sv_list   = []
		self.content_c_list    = []
		self.case_list         = []
		self.warning_list      = []
		self.deps_net          = []

	def EnvPathCheck(self,evn_var_name,log) :
		env_var_path = os.getenv(evn_var_name)
		if env_var_path != None :
			env_var_path = env_var_path.strip();
			if env_var_path[-1] != '/' :
				env_var_path += '/'
			if os.path.exists(env_var_path) == False :
				log.logger.error('Environment Var ${'+evn_var_name+'} path is invalid!')
				return 'None'
			log.logger.info(evn_var_name+' = ' + env_var_path)
		else :
			log.logger.error('Environment Var ${'+evn_var_name+'} doesn\'t exist! Please set it in setenv and source setenv!')
			return 'None'
		return env_var_path

	def GetEnvPath(self) :
		self.run_path   = self.EnvPathCheck('RUN_PATH',self.log)
		self.case_path  = self.EnvPathCheck('CASE_PATH',self.log)

	def RationalizationPath(self,folder_url) :
		if folder_url.strip()[-1] == '/' :
			folder_url = folder_url.strip()[0:-1]
		#if folder_url.strip()[0] == '/' :
		#	folder_url = folder_url.strip()[1:]
		if folder_url.strip()[0:2] == './' :
			folder_url = folder_url.strip()[2:]
		return folder_url

	def GenOutputFolderRelativelevel(self,folder_url='') :
		if os.getcwd() != self.run_path[0:-1] :
			os.chdir(self.run_path)
			self.log.logger.info('Go to run_path')
		folder_url = self.RationalizationPath(folder_url)
		if os.path.exists(folder_url) == False :
			folder_list = folder_url.split('/')
			relativelevel = len(folder_list)
			self.log.logger.info('Simulation path: '+folder_url+' doesn\'t exist and build simulation folder! relativelevel = '+str(relativelevel))
			for folder in folder_list :
				if os.path.exists('./'+folder) == False :
					sys_cmd = 'mkdir '+folder
					os.system(sys_cmd)
				os.chdir('./'+folder)
			os.chdir(self.run_path)
			return relativelevel
		else :
			os.chdir(folder_url)
			output_folder_path = os.getcwd();
			relativepath = output_folder_path[len(self.run_path):]
			if relativepath == '' :
				relativelevel = 0
			else :
				relativelevel = len(relativepath.split('/'))
			os.chdir(self.run_path)
			self.log.logger.info('Simulation path: '+folder_url+' has existed and relativelevel = '+str(relativelevel))
			return relativelevel

	def RelativePath(self,open_file_name,content,opt='',addnum=0) :
		file_url = content[len(opt):].strip()
		if(file_url.strip().startswith('~')  == True):
			file_url= os.environ['HOME']+'/'+file_url[1:]
		try:
			indx = file_url.index('//')
			file_url = file_url[:indx]
			file_url = file_url.strip()
		except:
			None
		if(file_url.startswith('/tools/') and ('ZEBU_SERVER' not in os.environ)):  #server need to remap tools url
			if os.path.exists('/newfolder'+file_url) == False :
				self.log.logger.error(file_url+' doesn\'t exist! Please check '+open_file_name)
				return False
		else:
			if os.path.exists(file_url) == False :
				self.log.logger.error(file_url+' doesn\'t exist! Please check '+open_file_name)
				return False
		relativefoder = ''
		for i in range(0,addnum) :
			relativefoder = relativefoder + '../'
		return opt+relativefoder+file_url

	def FindSpecifyFile(self,file_url,filelist_paths,opt) : 
		with open (file_url,'r') as fp0 :
			for fp0_details in fp0 :
				if fp0_details.strip().startswith(opt) == True :
					file_url_internal = self.ChangeEnvVar2EnvContent(file_url,fp0_details.strip()[len(opt):].strip())
					if(file_url_internal == False):
						return False
					if os.path.exists(file_url_internal) == False:
						self.log.logger.error(fp0_details.strip()+' doesn\'t exist in the list of '+ filelist_paths[-1])
						return False
					file_url_internal =  self.RelativePath(file_url,file_url_internal,'',0)
					if file_url_internal == False :
						return False
					filelist_paths.append(file_url_internal)
					self.FindSpecifyFile(file_url_internal,filelist_paths,opt)

	def ChangeEnvVar2EnvContent(self,base_file,file_url) :
		if ('$' in file_url) :
			file_url = file_url.replace('(','')
			file_url = file_url.replace('{','')
			file_url = file_url.replace(')','')
			file_url = file_url.replace('}','')
			file_url = os.path.expandvars(file_url)
			if ('$' in file_url):
				st = file_url.index('$')
				ed = file_url.index('/',st)
				self.log.logger.error('Environment Var {%s} Replace Failed ! Please Check %s' %(file_url[st+1:ed],base_file))
				file_url = False
		return file_url

	def GetAllFile(self,filelist_url,fdefine_lists,src_file_or_folder) :
		try:
			indx = filelist_url.index('//')
			filelist_url = filelist_url[:indx].strip()
		except:
			None
		#self.deps_net.append(src_file_or_folder+' : '+filelist_url.strip()+'\n')
		if(os.path.exists(filelist_url) == False or os.path.isfile(filelist_url) == False):
			self.log.logger.error('filelist_url = ' + filelist_url + ' doesn\'t exist! Please check ' + src_file_or_folder)
			return False
		try:
			with open (filelist_url,'r') as fp0 :
				fp0_details = list(fp0)
		except:
			self.log.logger.error(f'{filelist_url} can\'t be read')
			return False
		de = DefContentEx(self.log,filelist_url,fp0_details,fdefine_lists)
		status,fp0_details = de()
		if(status == False):
			return False
		for atom in fp0_details:
			if atom.strip().startswith('//') == False and atom.strip().startswith('#') == False and len(atom.strip()) != 0 :
				if self.ContentAnalysys(filelist_url,atom,fdefine_lists) == False :
					return False
		return True

	def ContentAnalysys(self,filelist_paths,fp_details,fdefine_lists) :
		if fp_details.strip().startswith('+incdir+') :
			temp = self.ChangeEnvVar2EnvContent(filelist_paths,fp_details.strip()[len('+incdir+'):])
			if(temp == False) :
				return False
			fp_details = '+incdir+'+temp
			self.deps_net.append(filelist_paths+' : '+fp_details.strip()+'\n')
			fp_details = self.RelativePath(filelist_paths,fp_details.strip(),'+incdir+',self.relativelevel)
			if fp_details == False :
				return False
			self.incdir_list.append(fp_details.strip()+'\n')
		elif fp_details.strip().startswith('-y') :
			temp = self.ChangeEnvVar2EnvContent(filelist_paths,fp_details.strip()[2:])
			if(temp == False) :
				return False
			fp_details = '-y '+temp
			self.deps_net.append(filelist_paths+' : '+fp_details.strip()+'\n')
			fp_details = self.RelativePath(filelist_paths,fp_details.strip(),'-y ',self.relativelevel)
			if fp_details == False :
				return False
			self.y_list.append(fp_details.strip()+'\n')
		elif fp_details.strip().startswith('-v') :
			temp = self.ChangeEnvVar2EnvContent(filelist_paths,fp_details.strip()[2:])
			if(temp == False) :
				return False
			#fp_details = '-v '+self.ChangeEnvVar2EnvContent(filelist_paths,fp_details.strip()[2:])
			fp_details = '-v '+temp
			self.deps_net.append(filelist_paths+' : '+fp_details.strip()+'\n')
			fp_details = self.RelativePath(filelist_paths,fp_details.strip(),'-v ',self.relativelevel)
			if fp_details == False :
				return False
			self.v_list.append(fp_details.strip()+'\n')
		elif fp_details.strip().startswith('-f') == True:
			temp = self.ChangeEnvVar2EnvContent(filelist_paths,fp_details.strip()[2:])
			if(temp == False) :
				return False
			fp_details = '-f '+temp
			self.deps_net.append(filelist_paths+' : '+fp_details.strip()+'\n')
			fp_details = self.RelativePath(filelist_paths,fp_details.strip(),'-f ',0)
			if fp_details == False :
				return False
			if self.GetAllFile(fp_details[3:].strip(),fdefine_lists,filelist_paths) == False :
				return False
		#elif fp_details.strip().startswith('-f') == False:
		else:
			fp_details = self.ChangeEnvVar2EnvContent(filelist_paths,fp_details.strip())
			if(fp_details == False) :
				return False
			fp_details = self.RelativePath(filelist_paths,fp_details.strip(),'',self.relativelevel)
			if fp_details == False :
				return False
			if fp_details.strip()[-2:] != '.c' and fp_details.strip()[-4:] != '.cpp' and fp_details.strip()[-2:] != '.S' and fp_details.strip()[-2:] != '.o' and fp_details.strip()[-4:] != '.vhd':
				self.content_sv_list.append(fp_details.strip()+'\n')
				self.deps_net.append(filelist_paths+' : '+fp_details.strip()+'\n')
			elif fp_details.strip()[-2:] == '.c' or fp_details.strip()[-4:] == '.cpp' or fp_details.strip()[-2:] == '.S' or fp_details.strip()[-2:] == '.o' :
				self.content_c_list.append(fp_details.strip()+'\n')
			elif fp_details.strip()[-4:] == '.vhd' :
				self.content_vhdl_list.append(fp_details.strip()+'\n')
		return True

	def Getfilelist(self,fdefine_lists) :
		filelist_paths = []
		if self.filelists is not '' :
			for file_atom in self.filelists.split():
				file_url = self.src_folder+'/'+file_atom
				file_url = self.RelativePath('-f',file_url,'',0)
				if file_url == False :
					return False
				if os.path.exists(file_url) == False :
					self.log.logger.error('filelist_paths = ' + file_url + ' doesn\'t exist! Please check forder' + self.src_folder)
					return False
				else :
					filelist_paths.append(file_url.strip())
		else :
			self.log.logger.error('Filelist is empty! Please specify filelists before instant GenFilelist!')
			return False
		for atom in filelist_paths :
			if self.GetAllFile(atom,fdefine_lists,self.src_folder) == False :
				return False
		return True

	def CheckSameFileContents(self,f0_path,f1_path):
		if(f0_path != f1_path):
			if(os.path.isfile(f0_path)):
				with open(f0_path,'rb') as fp0,open(f1_path,'rb') as fp1:
					line0_list = fp0.read()
					line1_list = fp1.read()
				if(line0_list != line1_list):
					self.log.logger.error('%s %s are different' %(f0_path,f1_path))
					return False
		return True

	def FindListSameIndex(self,src_list,same_cont):
		indx_lists = []
		while(1):
			try:
				j = src_list.index(same_cont,j)
				indx_lists.append(j)
				j += 1
			except:
				break;
		return indx_lists
			
	def CheckRepetitionFile(self,content_list) :
		if(len(content_list) > 0):
			if(os.path.isfile(content_list[0].strip())):
				indx = 0
				file_name_lists = []
				for atom in content_list:
					file_name_lists.append(atom.split('/')[-1])
				#print(file_name_lists)
				rst_content_list = []
				while indx < len(content_list) :
					num = file_name_lists.count(file_name_lists[indx])
					if(num == 1):
						rst_content_list.append(content_list[indx])
					else:
						#print('%s = %d ' %(file_name_lists[indx].strip(),num))
						compare_indx_lists = []
						j   = 0
						for i in range(0,num):
							j = file_name_lists.index(file_name_lists[indx],j)
							compare_indx_lists.append(j)
							#print('%d %s' %(j,content_list[j]))
							j += 1
						#print(compare_indx_lists)
						for i in range(0,len(compare_indx_lists)-1):
							#if(self.CheckSameFileContents(content_list[compare_indx_lists[i]].strip(),content_list[compare_indx_lists[i+1]].strip()) == False):
							if(filecmp.cmp(content_list[compare_indx_lists[i]].strip(),content_list[compare_indx_lists[i+1]].strip()) == False):
								self.log.logger.error('%s %s are the same name but different contents!'%(content_list[compare_indx_lists[i]].strip(),content_list[compare_indx_lists[i+1]].strip()))
								return False
						for i in range(len(compare_indx_lists)-1,0,-1):
							#print(compare_indx_lists[i])
							self.warning_list.append('Repetition path = %s need to be deleted \n' %(content_list[compare_indx_lists[i]].strip()))
							del content_list[compare_indx_lists[i]]
							del file_name_lists[compare_indx_lists[i]]
						rst_content_list.append(content_list[compare_indx_lists[0]])
					indx += 1
				return rst_content_list
			else:
				return content_list
		else:
			return content_list

	def GetUniqueFile(self) :
		self.incdir_list = self.CheckRepetitionFile(self.incdir_list)
		if(self.incdir_list == False):
			return False
		self.y_list = self.CheckRepetitionFile(self.y_list)
		if(self.y_list == False):
			return False
		self.v_list = self.CheckRepetitionFile(self.v_list)
		if(self.v_list == False):
			return False
		self.content_sv_list = self.CheckRepetitionFile(self.content_sv_list)
		if(self.content_sv_list == False):
			return False
		self.content_c_list = self.CheckRepetitionFile(self.content_c_list)
		if(self.content_c_list == False):
			return False
		self.content_vhdl_list = self.CheckRepetitionFile(self.content_vhdl_list)
		if(self.content_vhdl_list == False):
			return False
		self.case_list = self.CheckRepetitionFile(self.case_list)
		if(self.case_list == False):
			return False
		return True
		
	def GetAllCasePath(self) :
		case_list = [];
		self.case_list = self.case_paths.split()
		if len(self.case_list) == 0:
			self.log.logger.warning('There is no case to add in filelist.f')
		indx = 0
		while indx < len(self.case_list) :
			case_url = self.case_path+self.RationalizationPath(self.case_list[indx])
			if os.path.isdir(case_url) == True :
				files = os.listdir(case_url)
				for atom in files :
					if os.path.splitext(atom)[1] == '.sv' :
						case_real_url = self.RelativePath('',case_url+'/'+atom,'',self.relativelevel) + '\n'
						if case_real_url == False :
							return False
						case_list.append(case_real_url)
			elif os.path.isfile(case_url) :
				case_list.append(self.RelativePath('',case_url,'',self.relativelevel) + '\n')
				if self.case_list[indx] == False :
					return False
			else :
				self.log.logger.error('Case: '+case_url+' doesn\'t exist!')
				return False
			indx = indx + 1
		self.case_list = case_list;

	def ClearContent(self) :
		self.incdir_list       = []
		self.y_list            = []
		self.v_list            = []
		self.content_sv_list   = []
		self.content_c_list    = []
		self.content_vhdl_list = []
		self.case_list         = []

	def CommonWriteFile(self,output_dir,file_name,contents_list):
		with open (output_dir+file_name,'w') as fp:
			fp.writelines(contents_list)

	def WriteFilelist(self,out_dir,file_name) :
		self.log.logger.info('Start to write '+out_dir+'/'+file_name+'.f')
		with open (out_dir+'/'+file_name+'.f','w+') as fp0 :
			fp0.writelines(self.incdir_list    )
			fp0.writelines(self.y_list         )
			fp0.writelines(self.v_list         )
			fp0.writelines(self.content_sv_list)
			fp0.writelines(self.case_list      )

	def WriteVhdlFilelist(self,out_dir,file_name) :
		if len(self.content_vhdl_list) != 0 :
			self.log.logger.info('Start to write '+out_dir+'/'+file_name+'.f')
			with open (out_dir+'/'+file_name+'.f','w+') as fp0 :
				fp0.writelines(self.content_vhdl_list)

	def WriteCFilelist(self,out_dir,file_name) :
		if len(self.content_c_list) != 0 :
			self.log.logger.info('Start to write '+out_dir+'/'+file_name+'.f')
			with open (out_dir+'/'+file_name+'.f','w+') as fp0 :
				fp0.writelines(self.content_c_list)

	def WriteVerdiFilelist(self,out_dir,file_name) :
		self.log.logger.info('Start to write '+out_dir+'/'+file_name+'.f')
		with open (out_dir+'/'+file_name+'.f','w+') as fp0 :
			fp0.writelines(['./comp_define.v\n']      )
			fp0.writelines(self.incdir_list      )
			fp0.writelines(self.y_list           )
			fp0.writelines(self.v_list           )
			if len(self.content_vhdl_list) != 0 :
				fp0.writelines(self.content_vhdl_list)
			fp0.writelines(self.content_sv_list)
	
	def MakefileGen(self,out_dir):
		with open(out_dir+'/makefile','w') as fpt:
			fpt.write('verdi_f:\n\tbsub -q verdi verdi -f filelist_verdi.f -sv -uvm -top tb_top &')

	def CompDefGen(self,out_dir):
		with open(out_dir+'/comp_define.v','w') as fpt:
			for atom in self.comp_def_extract:
				fpt.write(atom+'\n')

	def __call__(self) :
		if(self.src_tdl_dicts == None):
			self.src_tdl_dicts = {self.output_folder:{'test':{'fdef':self.fdefine_lists}}}
		else:
			test_value = list(self.src_tdl_dicts.values())[0]
			if(self.cmd_line_opts['so'] == None or (self.cmd_line_opts['so'] == True and os.path.exists(test_value['data_base']+'/compile/simv') == False)):
				self.output_folder = test_value['data_base'] + '/compile'
				self.output_folder = self.RationalizationPath(self.output_folder)
				if(self.cmd_line_opts['rp'] == None):
					self.relativelevel = 0
				else:
					self.relativelevel = self.GenOutputFolderRelativelevel(self.output_folder)
				if(self.Getfilelist(test_value['fdef']) == False):
					self.CommonWriteFile(self.output_folder,'/filelist_depend_net.rep',self.deps_net)
					return False
				if(self.GetAllCasePath() == False):
					self.CommonWriteFile(self.output_folder,'/filelist_depend_net.rep',self.deps_net)
					return False
				if(self.GetUniqueFile() == False):
					self.CommonWriteFile(self.output_folder,'/filelist_depend_net.rep',self.deps_net)
					return False
				if(bool(self.warning_list) == True):
					self.CommonWriteFile(self.output_folder,'/filelist_warning.rep',self.warning_list)
					self.log.logger.info('filelist_warning.rep has been generated!')
				self.CommonWriteFile(self.output_folder,'/filelist_depend_net.rep',self.deps_net)
				self.WriteFilelist(self.output_folder,'filelist')
				self.WriteVhdlFilelist(self.output_folder,'filelist_vhdl')
				self.WriteCFilelist(self.output_folder,'filelist_c')
				self.WriteVerdiFilelist(self.output_folder,'filelist_verdi')
				self.MakefileGen(self.output_folder)
				self.CompDefGen(self.output_folder)
				self.ClearContent()
			else:
				self.log.logger.info('[Flow] Bypass Vcs Compile')
		return True

if __name__ == '__main__' :
	parser = OptionParser();
	
	parser.add_option("-f","--filelist",action="store",type="string",dest="filelist",help="specify all file lists in ${BUILD_PATH}");
	parser.add_option("-o","--output",action="store",type="string",dest="output",help="specify an output folder");
	parser.add_option("-c","--cases",action="store",type="string",dest="cases",help="specify cases to wrate in filelist.f");
	parser.add_option("-d","--define",action="store",type="string",dest="define",help="specify define to extract");
	(options,args) = parser.parse_args();
	
	#Output log infomation
	log = Logger('GenFilelist.log','w+',level='info')
	log.logger.info('---------- Start to extract file list ----------')
	if options.output == None :
		log.logger.error('Output is empty! Please use -o to specify output folder!')
		exit(1)
	
	#split file list and generate all file list absolute path
	if options.filelist == None :
		log.logger.error('Filelist is empty! Please use -f to specify filelists!')
		exit(1)

	if(options.cases == None):
		cases = ''
	else:
		cases = options.cases

	if(options.define == None):
		define = ''
	else:
		define = options.define

	el = GenFilelist(log,'/project/aaron/mc50/npu_sys_r2_verif/verif/npu_sys/filelist',options.filelist,cases,options.output,define)
	el.filelist_path = os.getcwd()+'/'
	el.run_path = os.getcwd()+'/'
	el.AutoExtractFilelist()
	
#InfoPrint = '[NOTE][GenFilelist.py]('+str(sys._getframe().f_lineno+1)+'): '

