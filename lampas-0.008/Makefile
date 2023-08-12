# Makefile for LAMPAS system files

#
# This makefile is only a wrapper for the Perl setup script, called setup.pl
#

BASEDIR=/opt/lampas
INITDIR=/etc/init.d
APPRM=/bin/rm
APPCP=/bin/cp
MKDIR=/bin/mkdir

install:
	./setup.pl install $(BASEDIR) $(INITDIR) $(APPCP) $(MKDIR)
	
uninstall:
	./setup.pl uninstall $(BASEDIR) $(INITDIR) $(APPRM) $(MKDIR)
