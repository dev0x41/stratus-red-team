---
title: Steal EC2 Instance Credentials
---

# Steal EC2 Instance Credentials

 <span class="smallcaps w3-badge w3-orange w3-round w3-text-sand" title="This attack technique might be slow to warm up or detonate">slow</span> 
 <span class="smallcaps w3-badge w3-blue w3-round w3-text-white" title="This attack technique can be detonated multiple times">idempotent</span> 

Platform: AWS

## Mappings

- MITRE ATT&CK
    - Credential Access


- Threat Technique Catalog for AWS:
  
    - [Unsecured Credentials: Cloud Instance Metadata API](https://aws-samples.github.io/threat-technique-catalog-for-aws/Techniques/T1552.005.html) (T1552.005)
  


## Description


Simulates the theft of EC2 instance credentials from the Instance Metadata Service.

<span style="font-variant: small-caps;">Warm-up</span>:

- Create the prerequisite EC2 instance and VPC (takes a few minutes).

<span style="font-variant: small-caps;">Detonation</span>:

- Execute a SSM command on the instance to retrieve temporary credentials
- Use these credentials locally (outside the instance) to run the following commands:
	- sts:GetCallerIdentity
	- ec2:DescribeInstances


## Instructions

```bash title="Detonate with Stratus Red Team"
stratus detonate aws.credential-access.ec2-steal-instance-credentials
```
## Detection


GuardDuty provides two findings to identify stolen EC2 instance credentials.

- [InstanceCredentialExfiltration.OutsideAWS](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_finding-types-iam.html#unauthorizedaccess-iam-instancecredentialexfiltrationoutsideaws) identifies EC2 instance credentials used from outside an AWS account.
- [InstanceCredentialExfiltration.InsideAWS
](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_finding-types-iam.html#unauthorizedaccess-iam-instancecredentialexfiltrationinsideaws) identifies EC2 instance credentials used from a different AWS account than the one of the EC2 instance.

See also: [Known detection bypasses](https://hackingthe.cloud/aws/avoiding-detection/steal-keys-undetected/).



## Detonation logs <span class="smallcaps w3-badge w3-light-green w3-round w3-text-sand">new!</span>

The following CloudTrail events are generated when this technique is detonated[^1]:


- `ec2:DescribeInstances`

- `ssm:DescribeInstanceInformation`

- `ssm:GetCommandInvocation`

- `ssm:SendCommand`

- `sts:GetCallerIdentity`


??? "View raw detonation logs"

    ```json hl_lines="6 90 130 170 210 250 295 335 375 415 455 495 535 575 615 655 695 735 775 815 855 902 936 970 1004 1038 1078 1118 1158 1198 1238 1278 1318 1358 1398 1438 1478 1518 1558 1598 1638 1678 1718 1758 1798"

    [
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "2a5178c8-b4c7-44ba-b066-1ecc79b7087c",
	      "eventName": "SendCommand",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:24Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": false,
	      "recipientAccountId": "017622104382",
	      "requestID": "ff024f6e-78cd-4f36-95cf-7179c6421e32",
	      "requestParameters": {
	         "documentName": "AWS-RunShellScript",
	         "instanceIds": [
	            "i-786a3A8B5C0d92eF4"
	         ],
	         "interactive": false,
	         "parameters": "HIDDEN_DUE_TO_SECURITY_REASONS"
	      },
	      "responseElements": {
	         "command": {
	            "alarmConfiguration": {
	               "alarms": [],
	               "ignorePollAlarmFailure": false
	            },
	            "clientName": "",
	            "clientSourceId": "",
	            "cloudWatchOutputConfig": {
	               "cloudWatchLogGroupName": "",
	               "cloudWatchOutputEnabled": false
	            },
	            "commandId": "f6887251-cdde-4251-a026-f50a25f521f7",
	            "comment": "",
	            "completedCount": 0,
	            "deliveryTimedOutCount": 0,
	            "documentName": "AWS-RunShellScript",
	            "documentVersion": "$DEFAULT",
	            "errorCount": 0,
	            "expiresAfter": "Aug 2, 2024, 10:23:24 AM",
	            "hasCancelCommandSignature": false,
	            "hasSendCommandSignature": false,
	            "instanceIds": [
	               "i-786a3A8B5C0d92eF4"
	            ],
	            "interactive": false,
	            "maxConcurrency": "50",
	            "maxErrors": "0",
	            "notificationConfig": {
	               "notificationArn": "",
	               "notificationEvents": [],
	               "notificationType": ""
	            },
	            "outputS3BucketName": "",
	            "outputS3KeyPrefix": "",
	            "outputS3Region": "us-north-2r",
	            "parameters": "HIDDEN_DUE_TO_SECURITY_REASONS",
	            "requestedDateTime": "Aug 2, 2024, 8:23:24 AM",
	            "serviceRole": "",
	            "status": "Pending",
	            "statusDetails": "Pending",
	            "targetCount": 1,
	            "targets": [],
	            "timeoutSeconds": 3600,
	            "triggeredAlarms": []
	         }
	      },
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "1d6a4901-4b35-4e4c-8569-a15fde667507",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:01Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "fc69ddbc-31ee-4435-80d7-d5186c01d2a1",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "8b5891ab-9638-4c56-aa27-8c43dacbf6fb",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:54Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "968528a1-fb69-454b-b895-87df48493598",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "a4ac2342-6c2d-4d54-9308-e20b7d537063",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:43Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "48ac6ca0-0d3c-4cca-80d4-65cca1e7cf50",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "8aa86ee3-7789-4248-a0b3-779a720a31bd",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:42Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "1a8b3f8f-0829-4e0c-bce4-a28c0e783f51",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "b379479b-05c9-4c3c-af4b-cbd43acf29e1",
	      "eventName": "GetCallerIdentity",
	      "eventSource": "sts.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:55Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "e46e7e10-ae9e-4170-b205-5d327c156416",
	      "requestParameters": null,
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "sts.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "ASIAP5CT9NN8EYVU1FXV",
	         "accountId": "017622104382",
	         "arn": "arn:aws:sts::017622104382:assumed-role/stratus-red-team-ec2-steal-credentials-role/i-786a3A8B5C0d92eF4",
	         "principalId": "AROALHCCSKSM395EGX3XN:i-786a3A8B5C0d92eF4",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-08-02T08:20:52Z",
	               "mfaAuthenticated": "false"
	            },
	            "ec2RoleDelivery": "1.0",
	            "sessionIssuer": {
	               "accountId": "017622104382",
	               "arn": "arn:aws:iam::017622104382:role/stratus-red-team-ec2-steal-credentials-role",
	               "principalId": "AROALHCCSKSM395EGX3XN",
	               "type": "Role",
	               "userName": "stratus-red-team-ec2-steal-credentials-role"
	            },
	            "webIdFederationData": {}
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "be2ec885-070c-4fc0-8c5a-11e8dfe65351",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:24Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "7f6ff28c-e7c0-4634-9d18-1f3e6157a5f5",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "f9d500d1-d469-409f-b8b0-b0fea46b927a",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:20Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "b4d8f210-46fc-4ca3-b03f-065a49cd9dbc",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "501997e8-265d-44e3-92ee-228e7e155cef",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:58Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "d76263e1-e1ab-4da1-9c74-ae146a06a390",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "1928dbd9-a8ff-4965-bfb7-cfd7884933cf",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:56Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "db31fb93-2471-4747-bd7b-0aa6d2ada9db",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "48c0979a-5d65-43f7-aa41-914d1ac0348b",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:55Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "c8f99ffe-e27c-41ab-84a4-9be8d40e8e96",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "73e1044f-14fd-4e57-a515-5fa1b33ee465",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:53Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "5377091e-7b64-4951-8d5b-38f5e6ed733a",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "fbe51d19-8701-4214-8715-479c3765fd63",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:50Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "9eb25ff8-973a-4bb8-a12c-2b27fdc5f434",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "0ad6b57e-2afc-4cbf-b618-b412445b3795",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:49Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "fd973fdc-43ed-418f-bd56-70c7bfb6beb0",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "ceffab54-0d57-4970-b1fd-6c735c624531",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:48Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "13bbbae5-9186-499a-8613-a50fcd752cad",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "abe4f64f-4edd-4269-888e-bd53a143a2b6",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:47Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "a475561e-0013-4f7e-80e7-9f2067b4b4bf",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "46e1e497-e386-4b89-9769-7c8d94d69c74",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:45Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "8b440237-44a9-4cad-8115-1d1015b9e7b4",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "92804077-0177-4385-bcf8-97b0291538fd",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:44Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "4bd629c0-ee97-4b2c-a779-2451cd91213a",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "061a2c00-e72a-4126-9487-1724c2f6a37a",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:40Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "f8b97bc6-cf13-476f-9e1b-5f005682ad9e",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "57f3b958-1c3b-458a-b60f-52310b597f49",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:39Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "32a9ae7b-8cae-4b6c-93ff-081ee7a5355b",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "394cf343-b9cf-48ce-8a94-e188656ae8ba",
	      "eventName": "DescribeInstances",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:56Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "7b9d34cc-91db-4ea0-9290-2897ad31b037",
	      "requestParameters": {
	         "filterSet": {},
	         "instancesSet": {}
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "ASIAP5CT9NN8EYVU1FXV",
	         "accountId": "017622104382",
	         "arn": "arn:aws:sts::017622104382:assumed-role/stratus-red-team-ec2-steal-credentials-role/i-786a3A8B5C0d92eF4",
	         "principalId": "AROALHCCSKSM395EGX3XN:i-786a3A8B5C0d92eF4",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-08-02T08:20:52Z",
	               "mfaAuthenticated": "false"
	            },
	            "ec2RoleDelivery": "1.0",
	            "sessionIssuer": {
	               "accountId": "017622104382",
	               "arn": "arn:aws:iam::017622104382:role/stratus-red-team-ec2-steal-credentials-role",
	               "principalId": "AROALHCCSKSM395EGX3XN",
	               "type": "Role",
	               "userName": "stratus-red-team-ec2-steal-credentials-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "a03d1afb-d68a-4e53-be36-17be89b1a3ee",
	      "eventName": "GetCommandInvocation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:54Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "d77be684-10e3-4da5-83ff-80e4abaf0818",
	      "requestParameters": {
	         "commandId": "f6887251-cdde-4251-a026-f50a25f521f7",
	         "instanceId": "i-786a3A8B5C0d92eF4"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "6a96b70b-0d0f-49f1-b649-b1531d02de50",
	      "eventName": "GetCommandInvocation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:36Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "9d0811fa-d945-4191-874a-c093553b3401",
	      "requestParameters": {
	         "commandId": "f6887251-cdde-4251-a026-f50a25f521f7",
	         "instanceId": "i-786a3A8B5C0d92eF4"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "7d7d6c2a-6ce0-40cf-9a83-9ceb78feafc3",
	      "eventName": "GetCommandInvocation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:30Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "705c99bd-7db7-434a-9678-5bcb19552940",
	      "requestParameters": {
	         "commandId": "f6887251-cdde-4251-a026-f50a25f521f7",
	         "instanceId": "i-786a3A8B5C0d92eF4"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "4bbece4b-580c-4cfa-8b01-344774458f69",
	      "eventName": "GetCommandInvocation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:25Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "9116a326-23fa-4f00-9f81-a52882bd18f7",
	      "requestParameters": {
	         "commandId": "f6887251-cdde-4251-a026-f50a25f521f7",
	         "instanceId": "i-786a3A8B5C0d92eF4"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "4b53af24-ec46-455f-9e60-f8f11235d226",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:23Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "57fdbc28-0188-4e33-8cc8-da4e0b474c52",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "2cf5bf3d-8b05-4083-89c8-d621fb29d315",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:22Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "dbf6c6cc-b01a-432c-a4d2-001e24ecbc4e",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "d0239fee-4dc5-4935-b2b0-3eb443760174",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:19Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "b75f1639-567d-4ad7-9b23-0912ada17f5a",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "3866bd7c-83fc-443a-8390-60f8037cea91",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:18Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "bf30e76a-ab54-4d13-bed7-ad994be43b7c",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "797de410-d0e0-4acf-b717-5e67ed39a467",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:17Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "7f890911-9b8f-4f97-876c-524b6d542b71",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "4c488fc8-23fc-4600-bd00-c0d51404c929",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:16Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "468b2426-d0ac-43c1-bd64-7f73ea91aa63",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "77b4b3f1-c381-4bbf-98a0-eb420141b8c4",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:14Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "4763a692-3f7e-4096-9006-cde225a71111",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "1323b061-297d-436c-909a-2052c0d47e6a",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:13Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "d9d0901b-b977-4767-86f9-821ffcecc364",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "3cfc7a2b-1e74-4292-8724-8dd29e0528ab",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:12Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "739b8f1d-2162-42b1-8187-0355da517057",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-SHA",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "d7463a04-25b0-4eb2-b329-867c6f6e6e17",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:11Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "d45d33ec-f498-4137-88cf-4f04073c269a",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "3578680d-0d63-43be-8bd5-484b6106ddfa",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:10Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "5653fd0f-27ce-4ac1-9ebb-d34389b01946",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "f3e31b50-d1e9-4e4f-bcdc-e1faed911fab",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:08Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "9e812fb7-0757-4659-aa0d-6c41bf6f7970",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "f48f89e8-af3b-4dea-9c5f-8f26687ade02",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:07Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "6d3d584f-5f25-478f-8549-78c410db8d14",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "00e9b1b8-2b23-4988-b872-bc650469750e",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:06Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "6c1953b3-468e-43f2-a058-2c6a926480a3",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "9a691968-b92a-4218-8c3b-f9183a2db5db",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:05Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "58d7aeab-490e-4a1c-8803-5994b6ad3e9c",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "9e3d2872-6af8-4137-8e17-276c8b34f357",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:04Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "72b94fe4-c828-4bdf-a002-7d2af722d687",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "f37811bd-6506-4785-b8e7-3a67885d9a31",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:03Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "3e2526bb-b0a8-4bcb-ae3b-5c88f6c04f1c",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "65965073-1feb-46ea-95b3-c7b90937c70f",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:23:00Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "eba9f797-3323-451c-93eb-f3c57269a524",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "e805f60c-ada5-4dc3-9f4d-636a9978b30a",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:59Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "80f88172-f800-48b4-94cb-d95cbecdbc8c",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "us-north-2r",
	      "eventCategory": "Management",
	      "eventID": "2a96648a-6f8a-4faa-b5fc-432fab0eee81",
	      "eventName": "DescribeInstanceInformation",
	      "eventSource": "ssm.amazonaws.com",
	      "eventTime": "2024-08-02T08:22:51Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "017622104382",
	      "requestID": "4f2d4d99-274a-4133-b122-abac714570c1",
	      "requestParameters": {
	         "filters": [
	            {
	               "key": "InstanceIds",
	               "values": [
	                  "i-786a3A8B5C0d92eF4"
	               ]
	            }
	         ]
	      },
	      "responseElements": null,
	      "sourceIPAddress": "18.236.253.47",
	      "tlsDetails": {
	         "cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
	         "clientProvidedHostHeader": "ssm.us-north-2r.amazonaws.com",
	         "tlsVersion": "TLSv1.2"
	      },
	      "userAgent": "stratus-red-team_c763d13b-d099-488a-bb3e-f57cb2fed240",
	      "userIdentity": {
	         "accessKeyId": "AKIAAM80VXLJF8NPK4VC",
	         "accountId": "017622104382",
	         "arn": "arn:aws:iam::017622104382:user/christophe",
	         "principalId": "AIDASSXYG8SJ3JDII10C",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   }
	]
    ```

[^1]: These logs have been gathered from a real detonation of this technique in a test environment using [Grimoire](https://github.com/DataDog/grimoire), and anonymized using [LogLicker](https://github.com/Permiso-io-tools/LogLicker).
