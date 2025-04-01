#!/tools/open/bin/python3
#-*-coding:UTF-8-*-
from optparse import OptionParser
import os
import re
import json
from Logger       import Logger
from DefContentEx import DefContentEx

class TdlManager(object) :
	
	'Creat Test description!'

	case_valid_rules         = ['test','template']
	opt_valid_rules          = ['+vhdl_opts','+vlog_opts','+vcs_opts','+sim_opts','+pre_comp','+pos_comp','+pre_sim','+data_base','+seed','+rt','+fdef','`ifdef','`ifndef','`else','`elsif','`endif','+dummy_log']
	define_valid_rules       = ['`ifdef','`ifndef','`elsif','`else','`endif']
	define_begin_valid_rules = ['`ifdef','`ifndef']
	define_end_valid_rules   = ['`endif']

	def __init__(self,log,tdl_default_path,tdl_names,test_names,vhdl_opts,vlog_opts,vcs_opts,sim_opts,filelist_def,tdef_lists,cmd_line_opts):
		self.log              = log
		self.tdl_default_path = tdl_default_path
		self.tdl_names        = tdl_names
		self.test_names       = test_names
		self.vhdl_opts        = vhdl_opts
		self.vlog_opts        = vlog_opts
		self.vcs_opts         = vcs_opts
		self.sim_opts         = sim_opts
		self.filelist_def     = filelist_def
		self.cmd_line_opts    = cmd_line_opts
		if(tdef_lists == None):
			self.tdef_lists = []
		else:
			self.tdef_lists = tdef_lists.split()

	def GetValidLine(self,file_contents):
		valid_contents = []
		for file_content in file_contents:
			file_content_strip = file_content.strip()
			if(file_content_strip.startswith('#') or file_content_strip.startswith('//') or file_content_strip == ''):
				continue
			else:
				valid_contents.append(file_content_strip)
		return valid_contents

	def CheckRules(self,file_path,file_contents) :
		start_cnt       = 0
		end_cnt         = 0
		case_start_flag = 0
		define_flag     = 0
		for indx in range(0,len(file_contents)):
			line_lists = file_contents[indx].strip().split()
			if(len(line_lists)>0) :
				if(line_lists[0].startswith('#') == False and line_lists[0].startswith('//') == False):
					if(line_lists[0] in TdlManager.case_valid_rules) :
						if(line_lists[-1][-1] != '{'):
							self.log.logger.error('%s line(%d) Syntax Error expect \'{\'' %(os.path.abspath(file_path),indx+1))
							return False
						else :
							case_start_flag = 1
							start_cnt = start_cnt+1
							#line_lists = file_contents[indx].strip()[0:-2].split()
						if(len(line_lists) > 3):
							#pattern = re.compile('\w+')
							#m = pattern.findall(file_contents[indx].strip())
							#if(len(m) > 4 or m[2] != 'extends'):
							if(line_lists[2] != 'extends'):
								#self.log.logger.error('%s line(%d) Syntax Error,please check keyword (%s) or invalid format' %(os.path.abspath(file_path),indx+1,m[2]))
								self.log.logger.error('%s line(%d) Syntax Error,please check keyword (%s) or invalid format' %(os.path.abspath(file_path),indx+1,line_lists[2]))
								return False
					elif(line_lists[0] in TdlManager.define_valid_rules):
						if(line_lists[0] in TdlManager.define_begin_valid_rules):
							define_flag = define_flag + 1;
						elif(line_lists[0] in TdlManager.define_end_valid_rules):
							define_flag = define_flag - 1;
					elif(line_lists[0] == '}'):
						end_cnt = end_cnt+1
						case_start_flag = 0
					else:
						if(line_lists[0] not in TdlManager.opt_valid_rules):
							self.log.logger.error('%s line(%d) Syntax Error %s is not valid tdl args' %(os.path.abspath(file_path),indx+1,line_lists[0]))
							return False
						if(case_start_flag == 0):
							self.log.logger.error('%s line(%d) Syntax Error %s is not in test description!' %(os.path.abspath(file_path),indx+1,file_contents[indx].strip()))
							return False
		if(start_cnt != end_cnt):
			self.log.logger.error('Syntax Error tdl {  } %d-%d can\'t match, please check %s' %(start_cnt,end_cnt,os.path.abspath(file_path)))
			return False
		if(define_flag != 0):
			self.log.logger.error('Syntax Error tdl `ifdef/`ifndef num can\'t match `endif num, please check %s' % os.path.abspath(file_path))
			return False
		return True

	def GetDefaultTdlFile(self,default_tdl_paths,tdl_names):
		all_tdl_paths    = []
		all_tdl_name     = []
		tdl_name_lists   = []
		specify_tdl_path = []
		if(os.path.exists(default_tdl_paths) and os.path.isdir(default_tdl_paths)):
			for root,subdirs,subfiles in os.walk(default_tdl_paths) :
				for subfile in subfiles :
					if os.path.splitext(subfile)[1] == '.tdl' :
						file_url = os.path.abspath(root+'/'+subfile)
						all_tdl_name.append(subfile)
						all_tdl_paths.append(file_url)
			if(tdl_names != None):
				tdl_name_lists = tdl_names.strip().split()
			if(bool(tdl_name_lists) == True):
				for tdl_name in tdl_name_lists:
					if(tdl_name in all_tdl_name):
						indx = all_tdl_name.index(tdl_name)
						specify_tdl_path.append(all_tdl_paths[indx])
						self.log.logger.info('Get Tdl Files :%s' %all_tdl_paths[indx])
					else:
						self.log.logger.error(tdl_name + ' specified dosen\'t exists!')
						return False
				return ' '.join(specify_tdl_path)
			else:
				return ' '.join(all_tdl_paths)
		else:
			self.log.logger.error(os.path.abspath(default_tdl_paths) + ' doesn\'t exists!')
			return False

	def CmdLineOpts(self):
		vhdl_opts_list = []
		vlog_opts_list = []
		vcs_opts_list  = []
		sim_opts_list  = []
		fdef_opts_list = []
		if(self.vhdl_opts != None):
			vhdl_opts_list = self.vhdl_opts.split()
			for indx in range(0,len(vhdl_opts_list)):
				vhdl_opts_list[indx] = '+vhdl_opts '+vhdl_opts_list[indx]
		if(self.vlog_opts != None):
			vlog_opts_list = self.vlog_opts.split()
			for indx in range(0,len(vlog_opts_list)):
				vlog_opts_list[indx] = '+vlog_opts '+vlog_opts_list[indx]
		if(self.vcs_opts != None):
			vcs_opts_list = self.vcs_opts.split()
			for indx in range(0,len(vcs_opts_list)):
				vcs_opts_list[indx] = '+vcs_opts '+vcs_opts_list[indx]
		if(self.sim_opts != None):
			sim_opts_list = self.sim_opts.split()
			for indx in range(0,len(sim_opts_list)):
				sim_opts_list[indx] = '+sim_opts '+sim_opts_list[indx]
		if(self.filelist_def != None):
			fdef_opts_list = self.filelist_def.split()
			for indx in range(0,len(fdef_opts_list)):
				fdef_opts_list[indx] = '+fdef '+fdef_opts_list[indx]
		return vhdl_opts_list,vlog_opts_list,vcs_opts_list,sim_opts_list,fdef_opts_list

	def GetAllFileDetails(self,tdl_paths,tdef_lists):
		file_contents = []
		file_contents_dict = {}
		if(tdl_paths == None):
			return file_contents_dict
		tdl_paths_list = tdl_paths.split();
		for tdl_path in tdl_paths_list:
			self.log.logger.info('Get Tdl %s Contents' %tdl_path)
			if(os.path.exists(tdl_path)):
				with open(tdl_path,'r') as fpt:
					one_file_contents = fpt.readlines()
				if(self.CheckRules(tdl_path,one_file_contents) == False):
					return False
				de = DefContentEx(self.log,tdl_path,one_file_contents,tdef_lists)
				status,one_file_contents = de()
				if(status == False):
					return False
				one_file_contents = self.GetValidLine(one_file_contents)
				file_contents = one_file_contents + file_contents
				file_contents_dict.update({os.path.abspath(tdl_path):file_contents})
				file_contents = []
			else :
				self.log.logger.error(os.path.abspath(tdl_path) + ' isn\'t exists!')
				return False
		return file_contents_dict

	def CreatTdlDictDetails(self,file_contents_dict) :
		one_test_extend_dict = {}
		tdl_dict             = {}
		one_test_details     = []
		pre_compile_list     = []
		pos_compile_list     = []
		pre_sim_list         = []
		#dummy_log_list       = []
		test_name            = 'DEFAULT_NULL'
		test_type            = 'DEFAULT_NULL'
		extends_name         = 'DEFAULT_NULL'
		for atom in file_contents_dict:
			self.log.logger.info('Create %s Tdl Details to Dictionary' %atom)
			for file_content in file_contents_dict[atom]:
				content_lists = file_content.strip().split()
				if(content_lists[0] == 'test' and len(content_lists)<4) :
					pattern = re.compile('\w+')
					test_name = pattern.findall(content_lists[1].strip())[0]
					if(test_name in tdl_dict):
						self.log.logger.error('Tdl Error. Has same test name : %s .Please check %s and %s' %(test_name,atom,tdl_dict[test_name]['file_url']))
						return False
					test_type = 'test'
				elif(content_lists[0] == 'test' and content_lists[2] == 'extends'):
					test_name = content_lists[1]
					if(test_name in tdl_dict):
						self.log.logger.error('Tdl Error. Has same test name : %s .Please check %s and %s' %(test_name,atom,tdl_dict[test_name]['file_url']))
						return False
					pattern = re.compile('\w+')
					extends_name = pattern.findall(content_lists[3].strip())[0]
					if(extends_name.strip() == test_name.strip()):
						self.log.logger.error('Tdl Error. %s can\'t extends self .Please check %s' %(test_name,atom))
						return False
					test_type = 'test'
				elif(content_lists[0] == 'template' and len(content_lists)<4) :
					pattern = re.compile('\w+')
					test_name = pattern.findall(content_lists[1].strip())[0]
					if(test_name in tdl_dict):
						self.log.logger.error('Tdl Error. Has same test name : %s .Please check %s and %s' %(test_name,atom,tdl_dict[test_name]['file_url']))
						return False
					test_type = 'template'
				elif(content_lists[0] == 'template' and content_lists[2] == 'extends'):
					test_name = content_lists[1]
					if(test_name in tdl_dict):
						self.log.logger.error('Tdl Error. Has same test name : %s .Please check %s and %s' %(test_name,atom,tdl_dict[test_name]['file_url']))
						return False
					pattern = re.compile('\w+')
					extends_name = pattern.findall(content_lists[3].strip())[0]
					if(extends_name.strip() == test_name.strip()):
						self.log.logger.error('Tdl Error. %s can\'t extends self .Please check %s' %(test_name,atom))
						return False
					test_type = 'template'
				elif(content_lists[0] == "}"):
					if(bool(pre_compile_list) == True):
						one_test_details.append(pre_compile_list)
					if(bool(pos_compile_list) == True):
						one_test_details.append(pos_compile_list)
					if(bool(pre_sim_list) == True):
						one_test_details.append(pre_sim_list)
					#if(bool(dummy_log_list) == True):
					#	one_test_details.append(dummy_log_list)
					one_test_extend_dict.update({'test_type':test_type})
					one_test_extend_dict.update({'extends_name':extends_name})
					one_test_extend_dict.update({'description':one_test_details})
					one_test_extend_dict.update({'file_url':atom})
					one_test_extend_dict.update({'has_merge':False})
					tdl_dict.update({test_name:one_test_extend_dict})
					test_name        = 'DEFAULT_NULL'
					extends_name     = 'DEFAULT_NULL'
					one_test_details = []
					pre_compile_list = []
					pos_compile_list = []
					pre_sim_list     = []
					#dummy_log_list   = []
					one_test_extend_dict = {}
				elif(content_lists[0] == '+pre_comp'):
					pre_compile_list.append(file_content)
				elif(content_lists[0] == '+pos_comp'):
					pos_compile_list.append(file_content)
				elif(content_lists[0] == '+pre_sim'):
					pre_sim_list.append(file_content)
				#elif(content_lists[0] == '+dummy_log'):
				#	dummy_log_list.append(file_content)
				else :
					one_test_details.append(file_content)
		return tdl_dict

	def SpecifyTdlDetails(self,test_names,tdl_dicts):
		spec_test_dict = {}
		out_tdl_dicts  = {}
		self.log.logger.info('Pick Out All Tdl Details in Dictionary')
		for one_tdl_dict in tdl_dicts:
			if(tdl_dicts[one_tdl_dict]['test_type'] == 'test'):
				out_tdl_dicts.update({one_tdl_dict:tdl_dicts[one_tdl_dict]})
		if(len(list(out_tdl_dicts.keys()))):
			return out_tdl_dicts
		else:
			self.log.logger.error('Has no case. Please check TDL')
			return False

	def MergeConfig(self,test_name,one_test_dict,all_test_dict):
		#print(111)
		#print('test_name is '+test_name)
		#print(one_test_dict)
		if(one_test_dict['extends_name'] != 'DEFAULT_NULL' and one_test_dict['has_merge'] == False):
		#if(one_test_dict['extends_name'] != 'DEFAULT_NULL'):
			sub_tdl_test = all_test_dict.get(one_test_dict['extends_name'])
			if(sub_tdl_test == None):
				self.log.logger.error('Can\'t find parents (%s) in %s test, please check %s' %(one_test_dict['extends_name'],test_name,one_test_dict['file_url']))
				return False
			else:
				#print(222)
				#print('test_name : '+test_name+' sub_test_name : '+one_test_dict['extends_name'])
				#print(one_test_dict)
				#print(sub_tdl_test)
				if(sub_tdl_test['extends_name'] == 'DEFAULT_NULL' or sub_tdl_test['has_merge'] == True):
					one_test_dict['description'] = one_test_dict['description'] + sub_tdl_test['description']
					#one_test_dict['has_merge'] = True
					#print('bbb')
					#print('test_name : '+test_name)
					#print(one_test_dict)
				else :
				#elif(sub_tdl_test['extends_name'] != 'DEFAULT_NULL' and sub_tdl_test['has_merge'] == False) :
					#print(333)
					#print(one_test_dict['extends_name'])
					#print(sub_tdl_test)
					sub_sub_tdl_test = self.MergeConfig(one_test_dict['extends_name'],sub_tdl_test,all_test_dict)
					#print(444)
					#all_test_dict[one_test_dict['extends_name']]['has_merge'] = True
					#print(sub_sub_tdl_test)
					if(sub_sub_tdl_test == False):
						return False
					#one_test_dict['has_merge'] = True
					one_test_dict['description'] = one_test_dict['description'] + sub_sub_tdl_test['description']
				one_test_dict['has_merge'] = True
				return one_test_dict
		else:
			return one_test_dict

	def display(self,dicts):
		for dict_atom in dicts :
			print('%s ' % dict_atom)
			print(dicts[dict_atom])
		
	def __call__(self):
		tdl_paths = self.GetDefaultTdlFile(self.tdl_default_path,self.tdl_names)
		if(tdl_paths == False):
			return False
		vhdl_opts_list,vlog_opts_list,vcs_opts_list,sim_opts_list,fdef_opts_list = self.CmdLineOpts()
		tdl_file_dict = self.GetAllFileDetails(tdl_paths,self.tdef_lists)
		if(tdl_file_dict == False):
			return False
		all_tdl_dict = self.CreatTdlDictDetails(tdl_file_dict)
		if(all_tdl_dict == False):
			return False
		out_tdl_dict = self.SpecifyTdlDetails(self.test_names,all_tdl_dict)
		if(out_tdl_dict == False):
			return False
		for test_name in out_tdl_dict:
			out_tdl_dict[test_name] = self.MergeConfig(test_name,out_tdl_dict[test_name],all_tdl_dict)
			if(out_tdl_dict[test_name] == False):
				return False
			out_tdl_dict[test_name]['description'] = out_tdl_dict[test_name]['description']+vhdl_opts_list+vlog_opts_list+vcs_opts_list+sim_opts_list+fdef_opts_list
		return out_tdl_dict

	def CreateJson(self,file_dir,file_name,src_dict):
		if(file_dir == None):
			file_dir = '.'
		if(file_name == None):
			file_name = 'test_tdl.tdl'
		out_file_path = file_dir+'/'+file_name
		fp = open(out_file_path,'w')
		json.dump(src_dict,fp,indent=2,ensure_ascii=False)
		fp.close()
		self.log.logger.info('Success Create Initial Tdl : %s' %os.path.abspath(out_file_path))
		return os.path.abspath(out_file_path)

if __name__ == '__main__':

	parser = OptionParser();
	parser.add_option("-f","--tdl_paths",action="store",type="string",dest="tdl_paths",help="Specify tdl file")
	parser.add_option("-t","--test_names",action="store",type="string",dest="test_names",help="Specify test case tdl path or file")
	parser.add_option("-o","--out_tdl_dir",action="store",type="string",dest="out_tdl_dir",help="Specify out tdl direction")
	(options,args) = parser.parse_args()

	tdl_paths     = options.tdl_paths
	test_names    = options.test_names
	out_tdl_dir   = options.out_tdl_dir

	log = Logger('TdlManager.log','w+',level='info')
	tm = TdlManager(log,tdl_paths,test_names)
	out_tdl_dict = tm()
	if(out_tdl_dict == False):
		exit(1)
	else:
		out_file_path = tm.CreateJson(out_tdl_dir,None,out_tdl_dict)


