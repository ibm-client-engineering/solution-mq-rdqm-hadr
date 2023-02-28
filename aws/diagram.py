from diagrams.aws.compute import EC2
from diagrams.aws.network import ELB
from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import ECS
from diagrams.aws.database import ElastiCache, RDS
from diagrams.aws.network import Route53
from diagrams.aws.network import TransitGateway
from diagrams.aws.network import VPCPeering
from diagrams.aws.network import VPC
from diagrams.aws.network import NATGateway, InternetGateway
from diagrams.aws.network import PublicSubnet, PrivateSubnet
from diagrams.aws.general import InternetAlt1
from diagrams.aws.network import ElbApplicationLoadBalancer as  ALB
#from diagrams.aws.network import VPCElasticNetworkInterface as ENI
from diagrams.aws.compute import EC2ElasticIpAddress as ENI






graph_attr = {
    "fontsize": "15",
    "bgcolor": "grey",
#    "margin": ".5",
        
}
node_attr={
#    "shape": "square",
#    "style": "rounded",
#    "color": "black",
    "fillcolor": "white",
    "fontcolor": "black",
    "fontsize": "14",
    "fontname": "Helvetica",
    "penwidth": "1",
    "width": "1",
    "fixedsize": "true",
    "padding": "0",
}
edge_attr={
    "margin": "1",
}
orange=Edge(color="ORANGE", style="bold")
green=Edge(color="GREEN", style="bold")
with Diagram("MQ-RQDM-HADR", show=False,curvestyle="curved", direction="BT",graph_attr=graph_attr,node_attr=node_attr,edge_attr=edge_attr,):
    


    with Cluster("MQ-RQDM-HADR Cluster"):
        
        with Cluster("VPC A") as vpc_a:
            ig_a = InternetGateway("Internet Gateway A")
            natgw_a = NATGateway("NAT Gateway A")
            
            with Cluster("MQ-A Cluster") as mq_a:
                alb_a=ALB("MQ A LB")
                with Cluster("ZONE A"):
                    mq_a_1 = EC2("dc1-1-mq") 

                with Cluster("ZONE B"):
                    mq_a_2 = EC2("dc1-2-mq")

                with Cluster("ZONE C"):
                    mq_a_3 = EC2("dc1-3-mq")

            with Cluster("ZONE D"):
                bastion_a = EC2("dc1-bastion")

            with Cluster("ZONE E"):
                mqipt_a = EC2("dc1-mqipt")

        [mq_a_1,mq_a_2,mq_a_3] >>  orange << alb_a 
        [mq_a_1,mq_a_2,mq_a_3] >>  green << natgw_a
        
        bastion_a >> ig_a

        with Cluster("VPC B") as vpc_b:
            ig_b = InternetGateway("Internet Gateway B")
            natgw_b = NATGateway("NAT Gateway B")

            with Cluster("MQ-B Cluster") as  mq_b:
                alb_b=ALB("MQ A LB")

                with Cluster("ZONE A"):
                    mq_b_1 = EC2("dc2-1-mq") 

                with Cluster("ZONE B"):
                    mq_b_2 = EC2("dc2-2-mq")

                with Cluster("ZONE C"):
                    mq_b_3 = EC2("dc2-3-mq")


            with Cluster("ZONE D"):
                bastion_b = EC2("dc2-bastion")

            with Cluster("ZONE E"):
                mqipt_b = EC2("dc2-mqipt")

            [mq_b_1,mq_b_2,mq_b_3] >>  orange  << alb_b 
            [mq_b_1,mq_b_2,mq_b_3] >>  green << natgw_b

            bastion_b >> ig_b

        with Cluster("DMZ Network") :
        
            alb_g=ALB("MQ Global LB")
#            internet=InternetAlt1("Internet") 
            alb_a >> orange << mqipt_a >> orange << alb_g 
            alb_b >> orange << mqipt_b >> orange << alb_g 
            #[mqipt_a,mqipt_b] >> alb_g >> [mqipt_a,mqipt_b] 
#            >> internet


        with Cluster("Cross Network") :
            [bastion_a , bastion_b] >>  TransitGateway("Transit Gateway")  >> VPCPeering("VPC Peering")
#        with Cluster("SSH Access Layer") :
#            ssh=InternetAlt1("Internet") 
        
        #[bastion_a,bastion_b] >> internet


