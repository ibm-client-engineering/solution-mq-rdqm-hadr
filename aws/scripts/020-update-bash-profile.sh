sudo su
su mqm
echo "export MQ_INSTALLATION_PATH=/opt/mqm" >> ~mqm/.bashrc
echo '. $MQ_INSTALLATION_PATH/bin/setmqenv -s' >> ~mqm/.bashrc
echo 'export PATH=$PATH:/opt/mqm/bin:/opt/mqm/samp/bin:' >> ~mqm/.bash_profile
