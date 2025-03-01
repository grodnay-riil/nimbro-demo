#include "ros/ros.h"
#include "std_msgs/String.h"
#include <sstream>

int main(int argc, char **argv)
{
    ros::init(argc, argv, "ros_publisher");
    ros::NodeHandle n;
    ros::Publisher chatter_pub = n.advertise<std_msgs::String>("/chatter", 1000);

    ros::Rate loop_rate(100);  // 100 Hz

    int count = 0;
    while (ros::ok())
    {
        std_msgs::String msg;
        std::stringstream ss;
        // ss << "Message number: " << count;
        //  Prepare a large string (4000 'c' characters)
        std::string large_string(4000, 'c');

        // Add the large string to the message
        ss << large_string;
        msg.data = ss.str();

        //ROS_INFO("%s", msg.data.c_str());
        ROS_INFO("%d",count);
        chatter_pub.publish(msg);
        ros::spinOnce();
        loop_rate.sleep();
        ++count;
    }
    return 0;
}

