#!/usr/bin/env python3
import argparse
import boto3
import datetime
import sys


parser = argparse.ArgumentParser(description='CloudWatch metrics CPUCreditUsage/CPUCreditBalance')
parser.add_argument('-r', '--region', help='Region name', dest='region', type=str)
parser.add_argument('-i', '--instance', help='Instance ID', dest='instance', type=str)
parser.add_argument('-w', '--warning', help='Warning value for CPU credit balance', dest='warning', type=int)

args = parser.parse_args()
try:
    cw = boto3.client('cloudwatch', region_name=args.region)

    get_cpu_credit_usage = cw.get_metric_statistics(
        Period=300,
        StartTime=datetime.datetime.utcnow() - datetime.timedelta(seconds=300),
        EndTime=datetime.datetime.utcnow(),
        MetricName='CPUCreditUsage',
        Namespace='AWS/EC2',
        Statistics=['Average'],
        Dimensions=[{'Name': 'InstanceId', 'Value': args.instance}]
    )

    get_cpu_credit_balance = cw.get_metric_statistics(
        Period=300,
        StartTime=datetime.datetime.utcnow() - datetime.timedelta(seconds=300),
        EndTime=datetime.datetime.utcnow(),
        MetricName='CPUCreditBalance',
        Namespace='AWS/EC2',
        Statistics=['Average'],
        Dimensions=[{'Name': 'InstanceId', 'Value': args.instance}]
    )

    cpu_credit_usage = get_cpu_credit_usage['Datapoints'][0]['Average']
    cpu_credit_balance = get_cpu_credit_balance['Datapoints'][0]['Average']

    print("CPUCreditUsage - " + str(format(cpu_credit_usage, '.3f')) + " | cpu_credit_usage=" + str(format(cpu_credit_usage, '.3f')))
    print("CPUCreditBalance - " + str(cpu_credit_balance) + " | cpu_credit_balance=" + str(cpu_credit_balance))

    if cpu_credit_balance < args.warning:
        print("WARNING. Low CPUCreditBalance")
        sys.exit(1)

except Exception as e:
    print("Error:", e)
    sys.exit(3)