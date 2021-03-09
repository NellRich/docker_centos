FROM centos
RUN yum update -y
RUN yum install passwd -y
COPY lb1.sh .
RUN chmod u+x lb1.sh
