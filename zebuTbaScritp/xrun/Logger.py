#!/tools/open/bin/python3
#-*-coding:UTF-8-*-
#import os
#import logging
#from logging import handlers
#
#class Logger(object) :
#
#	level_relation = {'debug':logging.DEBUG,'info':logging.INFO,'warning':logging.WARNING,'error':logging.ERROR,'critcal':logging.CRITICAL}
#	
#
#	def __init__(self,filename,filemode='a+',outmode='normal',level='debug',when='D',maxBytes=0,backupCount=3,fmt='%(pathname)s[line:%(lineno)d]-[%(levelname)s]:%(message)s') :
#		self.log_colors_config = {'DEBUG': 'white','INFO': 'green','WARNING': 'yellow','ERROR': 'red','CRITICAL': 'bold_red',}
#		self.logger = logging.getLogger(filename)
#		self.logger.setLevel(self.level_relation.get(level))
#		format_str = logging.Formatter(fmt)
#		sh = logging.StreamHandler()
#		sh.setFormatter(format_str)
#		self.logger.addHandler(sh)
#		if outmode == 'normal' :
#			fh = logging.FileHandler(filename,filemode)
#			fh.setFormatter(format_str)
#			self.logger.addHandler(fh)
#		elif outmode == 'time' :
#			if os.path.exists(filename) :
#				os.system('rm -rf '+filename)
#			th = handlers.TimedRotatingFileHandler(filename=filename,when=when,backupCount=backupCount,encoding='utf-8')
#			th.setFormatter(format_str)
#			self.logger.addHandler(th)
#		elif outmode == 'size' :
#			fh = handlers.RotatingFileHandler(filename=filename,mode=filemode,maxBytes=maxBytes,backupCount=backupCount,encoding='utf-8')
#			fh.setFormatter(format_str)
#			self.logger.addHandler(fh)
import logging
import colorlog
 
class Logger(object):

	level_relation = {'debug':logging.DEBUG,'info':logging.INFO,'warning':logging.WARNING,'error':logging.ERROR,'critcal':logging.CRITICAL}
	log_colors_config = {'DEBUG':'cyan','INFO':'green','WARNING':'yellow','ERROR':'red','CRITICAL':'blue'}
	log_format = '%(log_color)s%(asctime)s %(filename)s [line:%(lineno)d][%(levelname)s]: %(message)s'
	file_format = '%(asctime)s %(filename)s [line:%(lineno)d][%(levelname)s]: %(message)s'
	data_format = '%m-%d %H:%M:%S'

	def __init__(self, filename,filemode='w',level='debug',act='w'):
		self.logger = logging.getLogger(filename)
		formatter = colorlog.ColoredFormatter(self.log_format,datefmt=self.data_format,log_colors=self.log_colors_config)
		self.logger.setLevel(self.level_relation.get(level))
		console_handler = logging.StreamHandler()
		file_formatter = logging.Formatter(self.file_format,self.data_format)
		console_handler.setFormatter(formatter)
		self.logger.addHandler(console_handler)
		if(act == 'w'):
			file_handler = logging.FileHandler(filename=filename,mode=filemode,encoding='utf8')
			file_handler.setFormatter(file_formatter)
			self.logger.addHandler(file_handler)
 
if __name__ == "__main__":
	log = Logger('log.log',level='debug',act='n')
	log.logger.info(1111)
	log.logger.error(2222)
