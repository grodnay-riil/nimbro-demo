#include "ros/ros.h"
#include "std_msgs/String.h"

int message_count = 0;

void chatterCallback(const std_msgs::String::ConstPtr& msg)
{
    message_count++;
    ROS_INFO("Received message count: %d", message_count);
}

int main(int argc, char **argv)
{
    ros::init(argc, argv, "ros_subscriber");
    ros::NodeHandle n;
    ros::Subscriber sub = n.subscribe("/chatter", 1000, chatterCallback);
    ros::spin();
    return 0;
}

