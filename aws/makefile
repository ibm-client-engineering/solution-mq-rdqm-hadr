#!/make
MAKEFLAGS += --no-print-directory
#MAKEFLAGS += -j2

include makefiles/000-init.mk
include makefiles/000-variables.mk
include makefiles/005-aws-ids.mk
include makefiles/010-info.mk
include makefiles/020-transit_gw.mk
include makefiles/030-security-group.mk
include makefiles/040-vpc.mk
include makefiles/050-subnets.mk
include makefiles/060-vpc-attach.mk
include makefiles/070-peering.mk
include makefiles/080-routes.mk
include makefiles/090-internet-gateway.mk
include makefiles/100-nat-gateway.mk
include makefiles/110-ssh-keys.mk
include makefiles/120-ec2.mk
include makefiles/130-ec2-ssh.mk
include makefiles/140-install-hosts.mk
include makefiles/150-DR-Queue.mk

# TODO UPDATE Info
# Cleanup temp filters
# add a delete function to the makefile


