from registry.redhat.io/ubi8

RUN dnf install gcc make cmake git wget -y && dnf clean all

RUN mkdir /opt/installer -p
RUN wget https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/mqadv_dev931_linux_x86-64.tar.gz && \
    tar -xvf mqadv_dev931_linux_x86-64.tar.gz -C /opt/installer/ && \
    rm -rf mqadv_dev931_linux_x86-64.tar.gz && \
    /opt/installer/MQServer/mqlicense.sh -accept  && \
    rpm -ihv /opt/installer/MQServer/MQSeriesRuntime-*.rpm  && \
    rpm -ihv /opt/installer/MQServer/MQSeriesGSKit-*.rpm  && \
    rpm -ihv /opt/installer/MQServer/MQSeriesClient-*.rpm  && \
    rpm -ihv /opt/installer/MQServer/MQSeriesSDK-*.rpm && \
    rm -rf /opt/installer/*

WORKDIR /opt/installer/mq-rdm/
RUN git clone https://github.com/ibm-messaging/mq-rdqm.git

WORKDIR /opt/installer/mq-rdm/mq-rdqm/samples/C/linux
RUN make all 
RUN chmod +x rdqmput 
RUN chmod +x rdqmget 
RUN mv rdqmput /usr/bin/ 
RUN mv rdqmget /usr/bin/
