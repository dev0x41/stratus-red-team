---
title: Download EC2 Instance User Data
---

# Download EC2 Instance User Data


 <span class="smallcaps w3-badge w3-blue w3-round w3-text-white" title="This attack technique can be detonated multiple times">idempotent</span> 

Platform: AWS

## Mappings

- MITRE ATT&CK
    - Discovery



## Description


Runs ec2:DescribeInstanceAttribute on several instances. This simulates an attacker attempting to
retrieve Instance User Data that may include installation scripts and hard-coded secrets for deployment.

See: 

- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html
- https://hackingthe.cloud/aws/general-knowledge/introduction_user_data/
- https://github.com/RhinoSecurityLabs/pacu/blob/master/pacu/modules/ec2__download_userdata/main.py

<span style="font-variant: small-caps;">Warm-up</span>: 

- Create an IAM role without permissions to run ec2:DescribeInstanceAttribute

<span style="font-variant: small-caps;">Detonation</span>: 

- Run ec2:DescribeInstanceAttribute on multiple fictitious instance IDs
- These calls will result in access denied errors


## Instructions

```bash title="Detonate with Stratus Red Team"
stratus detonate aws.discovery.ec2-download-user-data
```
## Detection


Through CloudTrail's <code>DescribeInstanceAttribute</code> event.

See:

* [Associated Sigma rule](https://github.com/SigmaHQ/sigma/blob/master/rules/cloud/aws/aws_ec2_download_userdata.yml)


## Detonation logs <span class="smallcaps w3-badge w3-light-green w3-round w3-text-sand">new!</span>

The following CloudTrail events are generated when this technique is detonated[^1]:


- `ec2:DescribeInstanceAttribute`

- `sts:AssumeRole`


??? "View raw detonation logs"

    ```json hl_lines="8 56 104 152 200 248 294 346 400 433 466 514 562 610 658 706 754 802 850"

    [
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::751353041310:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:751353041310:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: K2-zhDkMqUq-g9q-R4ks6tltFzD63SUSxwKCTu5riJZoSD2q1xthgx-uUJ0ES-JqWPLhTUEHsklWqMDa1NqCV9zjmM_HU5bzubi61HQEvxzFcppL-MtX639POzt6cD5-pTLVsUW6YAT9JzLX4c4Afn3rPb-F9HrcqUBa8P9MXv5BtTbvfHYYeLuFbf8LOS3b2v6c_Mytt7ag-xgRM54brHGy3Esp0JNbejXPCvlzvkmtppUxCs-Sq561B4o7P89gymFqqIY10tNagPMAiM7JVhidM_NzBCkF1Q3XvOw7BTrBnXT5v-g7oadbGoZ1vVe_QsoZwDTQqWAF5zniUgu89LFxiUuEZhpeirUGnTZbkIubQ4J6OCDsCmO1lDz521qUfqpthJ9M5MzznWoYyXb-Ht38YTD81mWbq1dak2t4st3uQUfNZnhbSZkA7a7D5JlgAKkoG6DXplVL-ll78WgVcAKcwSJZ29wp1SE3U6zJ09Sz6ZEuSbeIbm2nyyYYCcTQoSNBU6qK08r_L_2qSiai_DYSh_HLspQtX4OwyPdtbJjAXrlPydgBY2lmniJvZ0nKv-zTzzk",
	      "eventCategory": "Management",
	      "eventID": "4839af5e-7b6a-4353-a5ef-41febc9a9fa8",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:37Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "d5c299e1-afd0-464f-92d7-8219b597c93b",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-95b86090"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: _AfGAKvvBmg1J3PRHkFjzWBCMkRgqZE3AD1OiUgYd6dVN4yRyc0XzZpxeYj1vesLCnaLrBmg3nMtcSfn6ymrP4eQibOdrpNv7x4GdFBzcg6H1jchddomWF3ZbTJLKGrzD_9ygAKiyk-mB_W1pK7UfIbjZ0CLgrxJW2fgNBZp1KzZDvT7gqpI9v4h3oip_Cs_oE_Cb__1O7IthlNNfbyOBPe_E9J8bpqWMD7_IRdcnNkbprGQQ-U794zyAVVcuAm29HZBUE4MFgslthGmi5_EZtYnAz6qbT6kc9gl0ilBJiVeJ_iru-ySGXONW_OauI9u_TLGk2TRbDwuAyl5t6UXVZgmVcRx6-OOfz1rn2FCbeW1u5pbWnGCxJgmFUDOOQZOR3dJX-oRCbfgvI-kKnDYmHPF2xTks_v56oFzhrONpxzDMUosZiumPm9lP5bPCXQSkuLxE4wFFA8WGTw2KSGJC-Imzy1ia6JXXb2g3Yzsk7uyy8Xs3ylGgclmmGG8ktNHsOctUcYY5lFKDlZXeo6Y-LWYP8s2o42sOvoSoHvYyXIY_oFveAN0TfUemD3JMYM5CDQwX-E",
	      "eventCategory": "Management",
	      "eventID": "5a44c114-2692-4701-bc09-faeb3f49b56d",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:37Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "712cd928-14d7-4783-ba9b-bfff98219325",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-3753597f"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: CPSSB4ODNNOXUXPaXrznW3jKaCViA5XJMIUfCdSr164Zl3rE4DaIvafRfxiNtM46GP9iOKo5UQuOJ8nl6LXDOBAipo-vFaNrFkI7kAh_9jW19q9-7L5rpv5xSSIcB8jrfrgwB966zc8KtjgTgXrE3oxkbTg60LCkPNlkWMjDaznlKQQHLJDNXu7E83sS3FIfZoBXiLuehqa-AYNeFIPMQIYcBpLGmGvPni-9EVG80mMZ4HdNtQa2aMKOUBfwXZisVmbyO2qGwPjfjVSgAJGX8wUVt4Uz8St_4O8hdL7RwQyJ-BrzTHQbt3ZzYXiet-nrKYwA8l5oIGsP7Hy9tSmnEUANWpZmboAkNc6qbxl1qfnfDxz-m80momRyAGFt7gBULvvnkYRiLJm-SQdm7dQFTbjpAUbjGA0aICT5k4KOLwQqR1iTm18jmA4NVWnAj0deEwdd46DkoI_-plbo6kpeSUD7NO1T2d_eLFOVRkha7G-fRiCaFDy2qRlBFaCd2RzEBce3UY5FG_QTn4jyWBZS0a6e2lwLpZcSuJ7wtOVGNRl8jV74VfybC60jV-XD82vjULLfdE7y",
	      "eventCategory": "Management",
	      "eventID": "0a4a4ee3-b1a7-4194-ab60-7465b4d5216e",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:36Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "59750908-8c42-4c10-b565-3427a5c9e8a2",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-751e5b81"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: CjrZQ3pjS8x41gRyVn1El8FK6p765IxIXyIqQRnIB_SfDAGSUpbxge9vshA3ll1RroDdvQSdsdV__Xg2WwzBoNuv7u-jnHv1H7K30GWcpYF459-XWgJX4dd7UpPYSbTER8yyz5EbkruXWoraLEsZEumgrAOhXqvBx9LdOgNlXcVn3KpofAndVdHt2qdkuQWBBtOMUTWfwg5S7MPZXrH3vcLaFiZ07n5FYJvrkInHNs1loQmLLWaTVnxOCqZjrdyhInF_ziEIFJnK4JAwkgeryGhNJN7KybjAbV80CVX6DazJ95aPze_8cqSBp2aPnBnaMUe4ftxFxOhglU6zXysDVeGSvwuKhFVJ5xxsZCAz4oUu9KWwdZx1_ufKxNkYWFVCv5cMbOyUeakUjFDalwpZYtCMW-Yi4wM6lR7uGA4uD_e2MnpAgXXnpQGnVz9-LQh_x2ceMDhkYjNq8omKnsUKDwYzIXrpzlz28T7iIlDg1CPoIKT1iQnCt6KP7RhciyEcuIHVCNtdB146CSNzdBVYUuTIfHp7pWsYUaFQXzeZpoqeNXBynb_LGlYexwGaq9ozpr5XgaU",
	      "eventCategory": "Management",
	      "eventID": "962d6fc2-b79e-4d8a-a7ab-36d72048c12e",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:36Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "8fa1c8fd-196a-4fbd-bab1-75f7c3e81de2",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-df55c340"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: ykssQBy7g1b7unmht52qJO9GqEuM9SZROkjhaP7a_XsSBjG5Sj0icyonTNZIsy7CQRd_hLUQNCGqq3oF2OfoVKGcZLCBe68vuBxZntrptcrIhXwHSuMadTIFiNo30KKEarrAdzXZGrjX9uVnR4CwRkYCqW-SjaKcGzXNen6kBffzqgwxqarePx8N-ogghgLxQ6BTIvOUmVV65LGkHYpfusv6nWqPrEqjg3DCHFD_hhs28eDHzWhwoly3mNff07K03YrFo9_l0gRPb1BTO7RBj2i__rbMeIFeZhnCy-8durAXqvCJ7MI4qEBh_hV6kpaJWV498NsGquTz6TOcY40En74o0novX2014oalF8bBqB8ZMGNGngBP_Dfomt_9g7hQGE6xH9eB9c_96CsB4BVw_hhMtzsKbLej201KxqoVh92RqDhFB3xldQh-TZ-IqxAHdRZKcdaLSFUCqUihk-eguiHfDWPT7QsmDZajE2A0-JiaXzGbadVofCb6dDQ8_KzbbMh2QKXltTW6XpbhKhaEaaTjQ_LTHdLLkirn2ft5vDCR4_uQWbqEV1FJI-Vtup2WB6GGFTM",
	      "eventCategory": "Management",
	      "eventID": "12b3736b-a8c7-4eaf-ae84-fa8dab5b5503",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:35Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "e9ac818a-e92c-4782-a26f-feb5555f1fe9",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-36d80d67"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: 3BD0zHY48CigR_ciFcRG14BzmH5vjQrT-QTgTppJiQ3ZWC5ZrnHzJJLNt4ddkfgHxuYlLAVYKkaY115GgvVQDWwjFH-cPsWOJc2G_a4GTJ8Znbv1aOkjTIKXYzxbO_KUS2szny9byykTkZ_SC41D-EENTd_WSdnuJGHuPghJOQzfd0D8PHoDLjObbikjQ4vfq1ewNinQXSZLNSoGs3DT0WikHe2uDVAaFHSwycFW8Bdp5y4bPVs-r6GxzoXN2JnEBxNUm7qtukD4J9-ymKfMtQwuLTcbjzb6r1gN5Jis_qDejUThSYK320IsCPJR9iR47yRyoS2Kuti6WhZ4CUjXv1-UhJpymDcM_g5i_NLQfnSy-T9qYXlj5kGSz_N9zF6jh0ZfmDsFyV_Avwov7bw6Jlgv922-ytF655M3skjZ31gf3-FScjt_sCzuKiaLTtHeSaZi4vTsHXtD-Gfl0W_BcZxTJeeJhuCzGyiLAhyXjIulmp4eWwuvBhuwPpkXIEbakpJ-pqx-rQVK9yp3NeqynD7tWeMtGQhiPl4lT1SsC1PBmJylWEimo560OKrRccI2JyXwKRE",
	      "eventCategory": "Management",
	      "eventID": "b6ed03db-7300-48b3-bdf4-b778a5c3e5a4",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:35Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "eea398fe-73d9-4393-ba25-ffe91a6858d1",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-2c3565b4"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "eventCategory": "Management",
	      "eventID": "cf589cd4-9633-4cc6-9b5c-c74f5a735fa5",
	      "eventName": "AssumeRole",
	      "eventSource": "sts.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:33Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "01d3746c-667c-4cf6-a149-fa51a50c2024",
	      "requestParameters": {
	         "durationSeconds": 900,
	         "roleArn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	         "roleSessionName": "aws-go-sdk-1722455550269043000"
	      },
	      "resources": [
	         {
	            "ARN": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	            "accountId": "321848314756",
	            "type": "AWS::IAM::Role"
	         }
	      ],
	      "responseElements": {
	         "assumedRoleUser": {
	            "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	            "assumedRoleId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000"
	         },
	         "credentials": {
	            "accessKeyId": "ASIA74KS09ZFFBFV9E6K",
	            "expiration": "Jul 31, 2024, 8:07:33 PM",
	            "sessionToken": "IQoJb3JpZ2luX2VjEHwaCWV1LXdlc3QtMSJIMEYCIQCmhF6hCfgQLCpXs5BNl3rezFcbOnrGHnQQ2xB6Eq34EAIhAJ746oP8DFnMU4kXsp422uImBq/EJapr8M+mHdV1DiEhKqsCCGUQARoMNzUxMzUzMDQxMzEwIgyczM9FaW3yVZowQgYqiAJOiTvzjvenlc5TP/18RaNfoLXOEaHfdV/MFZYEk1kiPd484q+NXdLe5qUO1aCJul9Mqb8UcGm+3c0E30UgDEhZPuxHiYxJMh3YOl1sDL+lz1KlqzFvgwsnz/iK0hDTZJRsiVzlxC0+vZDO4zW/GeT00JaqvbL/ES9DUMpoeTYJP4IAC5kmKvaSQhOyUz3VrJil/ieY2yZJ8Rwys6ogwpyVW3qtjFn89U45gRQspXslHzw/agwq419KfqSCVhQo4eBdN8sxuPbtwNI2/2Jgm3dd1ar5bb5oukFGnFGqXGuloeJzKmIjvBEpLfI5S1ZpAZp10fQdTfCj9VSdtGt4to1q5l11NaTgyiowgayqtQY6nAFxeUTuFIMlUZNzZE9Zz+FK0cBpajKVxmCQ5VQZQopSB5eVyTadj52jy5eO0LBwmgBPebBOUU60m8aOaiSRmQQOgld7X0B0xJSWVtb7yGyH686vUQM1xIVAg3aCUTObuzPv0ku4fyksvv5SFXxCxT4N8x46PlYONgq3h4T42KeOii1slPrqf47Kkjic8Mx5ZbuGUEeVkWhQodhpn2g="
	         }
	      },
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "sts.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "AKIAMJ2320ZAXACWCPJI",
	         "accountId": "321848314756",
	         "arn": "arn:aws:iam::321848314756:user/christophe",
	         "principalId": "AIDA2Q68JMYYLLXFIRZ7",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "eventCategory": "Management",
	      "eventID": "eebae605-3664-4560-a248-17d33f9ef6ef",
	      "eventName": "AssumeRole",
	      "eventSource": "sts.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:33Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "bf358b35-961d-4c8b-bcfd-82b647eb825c",
	      "requestParameters": {
	         "durationSeconds": 900,
	         "roleArn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	         "roleSessionName": "aws-go-sdk-1722455550269043000"
	      },
	      "resources": [
	         {
	            "ARN": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	            "accountId": "321848314756",
	            "type": "AWS::IAM::Role"
	         }
	      ],
	      "responseElements": {
	         "assumedRoleUser": {
	            "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	            "assumedRoleId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000"
	         },
	         "credentials": {
	            "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	            "expiration": "Jul 31, 2024, 8:07:33 PM",
	            "sessionToken": "IQoJb3JpZ2luX2VjEHwaCWV1LXdlc3QtMSJGMEQCIGtdAaKvKWRr68HA5EuufjSaCXHXZnVIFXtcysfmdV/qAiArZ3qZEA79pcSrcLFLCIuVD3dPLjHSDUSKnQM8ASuS+SqrAghlEAEaDDc1MTM1MzA0MTMxMCIMSyGMmjPPsflcyznaKogCyZDL1PjL7bbXv3wq5QAeiC+gwSjc7zIaP9DtuEOHE/xodo5IvKBkdc0AdddeBkITU6mSNeg93iEh40BGn2mjECaGWxZXoyqkODfyg5iPU/QWPdIEuXXU9h46o9ZOLxnO8Rc4rOiIAQK0Q4tq4BE9h28QsYmQqA/wby03DDQJUpVLY3kJe7PTx20aBv7nuzExo+a5zTzJnYKhl3tzeNxJSXQRjZkAlrQZmaqf9o3Ob/uY2VBPtCu//9yglgFcFmVGGG3O4VFbJgirnPteLpwNlz2+kWpcxqCFOk1LpPqVXxKggJgkXhGXe+M17hVGuJOCWKnsb24QCT4mTtskg4PiEZ+cojYR5N2yMIGsqrUGOp4BBBrc2If35t6Jl0TKlzbemFVrgT0JCaHP1/soUTSVYTuqjf+AbRdCrr08Onez3Htr20rkPlMJj08Gpo9B7MBc4Xc5RdhgaxBUDlLlYOtmGZfSF7Y9K3ZHT2UnT6sS4IMMQfwzhGIwRMT5TTK4pm6OEqPZ1ULl0rI8nWUIr29oLsKp+0iPpXIm09jp2f7fE1FOZqBP4nrSQjyWl/LpL44="
	         }
	      },
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "sts.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "AKIAMJ2320ZAXACWCPJI",
	         "accountId": "321848314756",
	         "arn": "arn:aws:iam::321848314756:user/christophe",
	         "principalId": "AIDA2Q68JMYYLLXFIRZ7",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "AccessDenied",
	      "errorMessage": "User: arn:aws:iam::321848314756:user/christophe is not authorized to perform: sts:AssumeRole on resource: arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	      "eventCategory": "Management",
	      "eventID": "4cf5dad6-648f-48eb-85a7-6181c5d79424",
	      "eventName": "AssumeRole",
	      "eventSource": "sts.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:31Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "4707e217-520c-4854-833e-179f3607230a",
	      "requestParameters": null,
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "sts.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "AKIAMJ2320ZAXACWCPJI",
	         "accountId": "321848314756",
	         "arn": "arn:aws:iam::321848314756:user/christophe",
	         "principalId": "AIDA2Q68JMYYLLXFIRZ7",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "AccessDenied",
	      "errorMessage": "User: arn:aws:iam::321848314756:user/christophe is not authorized to perform: sts:AssumeRole on resource: arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	      "eventCategory": "Management",
	      "eventID": "67fa9341-bd06-4ceb-a8b8-6815522b5a1b",
	      "eventName": "AssumeRole",
	      "eventSource": "sts.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:31Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.08",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "13c6f460-608a-487b-82df-9ad531b39a6f",
	      "requestParameters": null,
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "sts.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "AKIAMJ2320ZAXACWCPJI",
	         "accountId": "321848314756",
	         "arn": "arn:aws:iam::321848314756:user/christophe",
	         "principalId": "AIDA2Q68JMYYLLXFIRZ7",
	         "type": "IAMUser",
	         "userName": "christophe"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: LB7cA78q30t1tPsWTMLmstV2qcxGVIDbeIQlzeLa9H7MPbjgPAHNoi51kZZmZ33zYw4qbgTCuvrDtE0vGEZRfg3WOLD6RjgUu-S9h-hnkY4DsAaweKHsmLzpRYc1iZ69Re7Yghrc9uua92glqVFHOCjGSYgk3RuA6BTQMfJxYEc4Y1LVk-NXUEWwPki_ubaTquUUHUudZbS6yRuyUInvSIMlA6t1P3Adv0uKpnPCPjdJ9oeF8x7i3oL0WuSx7QVWW_p4fX5teDwqmm_O6wHslKfrCBaD56so68LXhYb1OoeTFsh5AmPX_jN5y_Xk7b5jdm-LmTNtmslSZ6Kaz30ThcPPsInsmOQYgrPeOCOixVHoKbedfYIb8V-KZsKhsryeFg5ap1Xo64XepKfWPEY2WsLWZpgOAJ6n9mlq6qVzsXb7XOvJ-rtaX4e6nRJczkf5oA3NCnKpUHckI0SW6mv0IeSmE79YKnD22mJ0Jk1mWQmu6Ojs03ijwK4bZAJ7KqgFd9OiGBiQHiYCYqLR6jhjr5Iw9z4r9Zu-Rk3L50nZ8Yodj9prBWQuGPapLAN-2zExiOPr3JI",
	      "eventCategory": "Management",
	      "eventID": "971a0ce7-1f66-4dba-918d-cd2a5b12ebe5",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:38Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "1d4bd0bb-0761-4c4e-9cf3-60eb78dc69be",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-eacdbb0b"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: VUo9HEgnkqejRmwZ981TtFTVCu8SFtMJJcOgZYlCFTsJTpYwp7FVaiOvMufhCY1iszVV-5YVWpcFtyZ3ygwVzqbJ4QStjDU_R92FtZMlO5oO-l-XVgaf8Z5JuyUs1ulVWrY25HY3Kt2L08win1DK-vtsE8-b4Ewe2-tDlTBHmKiR8mfUD3BO_fH73yhWkLoDD1s0Pa4hKv3auv5jGd-564yRXr0Rx_IGTFoi2hBTs5VN9-MQOc8VUlw-RMyZu-YT-dRajZ9TdH3VRvyGzLKuhrcu-fwBcXhUaHR99Z5HvPiQjRpvkMb9lth6oMpkMaZenHwm67D8l2xDca6-2GTMLatZbJZO43gibKowBQPku1aX_ji7KwMjK4qec-p0pwexuc7wfaxiej9lqGg3P0Zhf2Zv8wq_5mj0IP9oWc_RwS_MIWxMtYQ_oMfn5qd6w9DkGxikX0H0VvG5sGdwv6QYr9BJHPmJRqy6vb6RK9N9t3ZTdm8NqJGlInmdKYwXEWvyaPofwoj-BhZhfuDYXyMOgDBaA6aOncL3_H3kQsV0YWvAqIZiGQsjb8ivWAnY0MpPYK_69_c",
	      "eventCategory": "Management",
	      "eventID": "0ee61554-ac1d-4c40-abde-2ff51473f180",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:35Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "c32c0316-5ddb-441a-bbdb-aaf2a6b9e44f",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-66a17941"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: uOFPYQO23u4TQn2JQmg4tRDYkzz74KyWtOKizw8XEkx3-OWmistPtzU2fOb6WQoI3PW7pMHipebgFskL2-k__VUGSdmyNRkCBGyz4YAIBQ_aFO_WZZ5qC2FPxzQEtb6EB34yQ4Blutwafq-hERt2vxzyyVWU2sg7vZB-ydJSYkpb5vClj5OY0qTANhe58P7DtwcGhfrusetkwZ6Qyk52M3ctvCVHeFg-dPU5fFit7Tn9HmsQ7D9zCB-_vHErBqOl497_y-gXeRCdaO7brcVkZerWLQtbpSKWy9_i0WT1SvwQ4-cGbVvKinApvGtdYT-WlvrV3DWyPhdQzbSQJru8yQKAwmp4vshdSjvQ8T4B5VjdqOuflOsRuciuOrF_o_ZKiQYDOXrrAI-Mkd9LNCvwe-DAS60EUV1wQDFFJEXWg4e2_AX1IB5G0LQwbARXBoYrK4tZe5SY_aNp-vePaCjUDkvM7SXdSiMc2NCxSrRd7QVUdgp8uH2iHelrO_g2c9N5Yk6B5rdqVOIeVziuR575r9U2slnzaS_VDgAiAKekNsqltWp_cw5RPQqUBU6w_H0Le9wevYM",
	      "eventCategory": "Management",
	      "eventID": "3178929b-eb35-4a1b-b479-de1ca5187fb9",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:35Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "1b702f59-5907-4faf-9f33-a187407f03c3",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-4cb766e5"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: Enl2ZFI8qzZz7FJbafChbyrAXg2YIjHajQvck025ERtfChE6SPPSWQgqVtk3hlhPmmXtygl2topFTLBMetoZpEkbrp12Jmy_tJvy8coKgQvYNRbwgexE1sgGHrFIR8lN-4kQFN8DwhrHJpJEnktXjp3resU01Or6e_LFeuTG64mgJd3586EywcHHGevMRLvK05jO0RMJqsg6b0cmKYpRUv2FxOKJhMCgGsiP4DhL3XGcXpfGKJ7HZnPG75uExMS35jH5ct2jTai8FEXolH0REk3zkQ5-siB6c-ZTim-4kzEf8NlVS5WMz4y224S-uZfzVCJF5V1tlpAAAcVDqXcCPPYnvDFCrAEvSHwVbz_J-4b0PsIwup0JrQjvO-Y_PCAlmEGdKqnjE6ByjPJ8t_kJ-1DbTZoQyBYxk9iy17MtSogtNbvheLUVRiWUfbFu-PGFNRrbsQLMveCKFWyDxohCcSIrt8wFZiHiW3GtSGcZEPGyIkx8J70WeW43xOdi2kqy2Qpy9IqDpI76QhdyOrq1I3w2mno52gIZ8DMcjteDEjpvpAVjBYQ7V61LAeV6sjkBlreXHcw",
	      "eventCategory": "Management",
	      "eventID": "66ffee8d-1866-43f6-b17e-4ffe3ddf8503",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:35Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "e58d7e06-a5eb-4a74-b8cd-d6f340b93b8f",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-346d369e"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: vdeCm58kZaHVcu0-M4yWQZUpPdeSvQM-HOZwlDrMda0wvu4tI52g4nlMc0Rr-8BzALqkpYMuU5gfkKjRboEAzaWBoLGR-MNnaDfrQoZRMHXd96e10UDh-IWDRcWvUGoS29l674DRl_WTDfwz5b021AAGHfMZS9NU1CXWZT3XvniJW0Q14EAovh_9HRYT0aQQqTBiF7M3KmaTaY4u1bCufp8Dx5zVbauuOnMDlXVAJhGHbSFCF8-ZzlK0D4kfdFboZSbIquw7xaMxjqD9LTBjl2K1g_2858Z41gZo4Km4lkjTPWXpoJtyYc3Fz3YSglZCutzv0CfWlDNziCj2SRPJeU0Y3Pro30Hczj_Z_knNWTauA_xr19CHjDRpmjab_BFA263eRFGZsZCFQXf1xlZBFSVvFEEBuo7hZ9USZ0hnoK3rq2njhNyDpefpqgIE8oWr82G0n9sqVVYj9TpX45obBsMHR-CXdnG5OsoQlrxl8-EjJYR2ugB6E3PhPFklgGf6Bj6I8P2tpQqqxGMHXcPlnj2tPoze4YzOlzrWhXi5aj7SuDoKgcYRm_R8WSKjUA1yBN7pFfI",
	      "eventCategory": "Management",
	      "eventID": "b307eaf9-2be2-44dd-b942-ce2bc8a3cc57",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:35Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "30ac0390-1bf8-41bc-af5b-a470776973f3",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-cee23f5f"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: VTgeZY1vPG9JN8RDG5_1wKNkdZA63luKUmEpRzFkvdZUvjd_rcKLffOZqwXDA20cPdJHu1l7vHPCLGfLM8Fb11o5jWDblvEI9qwX8qPQrLXY2_eOGXR8PLPa_uSLkcCKg4f38m_O0kz7Ss9Re9cvEKgSeD6ARS2Z3cN525WfqGuMCutpegkhku4TeuGzROO7rfPShnztzzxqtN0gdb4g7eIlfUIxEPSAhGChhW8eDQCetI3WtssEwXQYkzHd6-9YIHxW8yw8P3enNKq3QgT2oaVMeOzZAFJDn6QukrYhFXu0Tr12gRnBNRWRpP5fFIoSwoMvd2AAhBTSAdpZwIv4_sN-aCGmR7QVs6sywfgXgJTOd6bKFMcM5nFp_-D0ZV-u057MMLcBc_mhrNU3vLIZ5aWoPSHaSkSyk6LlUpPRiuoASfphMxGjbVCeof0r9chjZtEi9bJE0DaRvPqYQTj4Bumpp4EO8PP7xUJ5XPKiDdUwxRF1zy_9pxLFL7hkkmAr-AAEtoGqPAfX9BtVS_HgahYXdC7lNRuHmmYmmgcDbOuU5yaHcrBMcEbr6JJXapgvJZlhXtg",
	      "eventCategory": "Management",
	      "eventID": "205f694d-35d4-4e33-9f38-f5e7a20ffa50",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:34Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "add1b208-55c2-4f2d-8b7a-cd9aeb2b177a",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-1780bff0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: nLsOD7QpVpUhY_D5_xjyMrx2F-tbtuHhu4c9a2WnPRM5-j5JMzduGPr7dEt-PwGW39koU0YG9NsH40_CiWm2POy8r3JRQWYpHy9YGMbIsk-lPk7u5BVYvDPhPswVHoxYQcubUkNE9MKzgUHD6--rhHlErfgmG-x3-E_x56A2qqvpJhCVEt5ZPDBpMsGDQBAA6sxgI13hiR9Vj3vXmokTk0pwl6VY_GWRTRGxoTSC0EnzwsbLMlyMrdnKcQOPOizQstA6FqAoKiwk3B1T36AMuZ3DFeFKBCwatonhnDeqVEp1HFs0v1qWqSPQ3CMcxFmVai0VlKB-gh24bJ2eYJSraA3XqkzMMpuXCsaP3gVvY50wV5AtbO6s2mcy2hFikUoH-J7VUkhnAUf5v1fW_M9n1MKJ3-JINpVmeMVWGKHy2hCtuV0nK5mckvWfo1pX1yGR7rC8hz8mdDUdMpaOydDrCIapx-NYuZqd_8SbaeetsrJu-EUK2YwLc4WocKHP3yW7OZlwkhUt4RvSpZqkiYJ-F-HZKLsQ4fs6Yr5qy2RiIepTENiSzuD5wI0iZW21XRS5DoYm",
	      "eventCategory": "Management",
	      "eventID": "330b18f1-2763-4429-acf9-7293a5604ef3",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:34Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "9df72845-fbec-4178-9713-adcbccb99499",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-42416187"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: x6ukywL8Prh8nVwqNu_jfGpoVhNz64Z2oWssU-lfo9LLvZgrVpP7_U8FCvEfahACLHt9q3SN5BHNoKIqpT6Nse1a8IDd5T5UFtN5NAbm-8IlIjrfta55z8CdeQuyYW8g4n4fdzLRFY7P-bCnEWRyA96Dj7dgYI0-3JwYfoxyD5LqbNAyZZzXs6HzhE-JC2cNtX7pAnJyY5iqd7yKcM4tQDl-A1paYlQXwmp9jeYbixy09q2yEWVn0GnmDZpc-1YJdX7-G9RWvGb55cgx6G6QwX_V8O3GlbUtJoy5L1yJF9VHSjpNGcUjC1_T6pZoOquGL6HC1P2j4oU_vvThGAuyJtZ5hlwZA313Jwfx-YoFU3kncWiw9IXtxpgc120lSkcUt46AE9Uc47TT8jzAbBJhhIeA1lw8eh89JNMPOrGx5pTVqnmHdC6mZ92mnS5Iae0oAXY-T406pDrEIkdXtv3cbMeuBUNGfvn3O6xteP0i0gZdNPhCPxkTEDZRF-EgQs3TD2TwWIdbcoVDpTvPbf74xNHaDBFtFmcW_TW0XwiisyiaM8Ho5VTvUUQohR-ForP1xTRupKo",
	      "eventCategory": "Management",
	      "eventID": "95da874e-1cbd-47df-bba6-26dd2ed9ad82",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:34Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "d94b9d47-13c6-46cf-a8c6-4d7a33d7b85c",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-68604a68"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "apiso-westcentral-3r",
	      "errorCode": "Client.UnauthorizedOperation",
	      "errorMessage": "You are not authorized to perform this operation. User: arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000 is not authorized to perform: ec2:DescribeInstanceAttribute on resource: arn:aws:ec2:apiso-westcentral-3r:321848314756:instance/* because no identity-based policy allows the ec2:DescribeInstanceAttribute action. Encoded authorization failure message: cfE6FKZ1sIRhbxBLmjIoehSeEmbpj_8jIPsfCPuACT9E_rFPauBJrhN3AIXtPobElUTbZgN33aeBcq_atGfmGm0miGiE4oW5CWSkQVTPR_f6bJd-5PHBgkv_Evot_3vhSyAyN1nKUAakmm_Ne9bkqWRYabIiS-XBNwhbA49faTNvYUuwjEZKCJbpnCI9ir6J_ijM7bmlE0UAdVKWzn26SSgvgV9C0ex-YJoFslO-85IYC_09Ar0piVJjpmvVR0q04uuHw_W57DWJYjIs8n_PYyaH9fhp794rgvDzdxorm4rFwIlZKaudBGmGg0VYtmQzNLsYFXEpMX42A72nhCdEHoxZoTCpLJFLVVl2l4Fiuieud-NQxn8clqRwIWitTKGxpzKUlrLDzYS0NMJwjSleSiBtS8wJ-4t3iB7Y42OP-XNKN2DquxpmT1yIurR0nykVlvZtCzXuUdH39Z8spGqxCPJgZwd9o0G1X2-IwiP4MNeWQzYM8ZjN4vLOgNZsP85gJnCQxZSk8Vfk6XlS550Zd113KMl05ej2nYOO5sDtQNXFYR0xN4fTaQSi6XHLgtuN1xmqFaU",
	      "eventCategory": "Management",
	      "eventID": "a7ca94eb-492f-41e9-b23d-e4875b795041",
	      "eventName": "DescribeInstanceAttribute",
	      "eventSource": "ec2.amazonaws.com",
	      "eventTime": "2024-07-31T19:52:34Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "321848314756",
	      "requestID": "8e437f72-d5eb-4c0a-b391-dd8d7f59eefb",
	      "requestParameters": {
	         "attribute": "userData",
	         "instanceId": "i-0c140b58"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "255.18.064.253",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "ec2.apiso-westcentral-3r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_f193d7d4-8114-40ff-acc9-a123d5463ff3",
	      "userIdentity": {
	         "accessKeyId": "ASIA4URVX2JM5MT0ZGK8",
	         "accountId": "321848314756",
	         "arn": "arn:aws:sts::321848314756:assumed-role/stratus-red-team-get-usr-data-role/aws-go-sdk-1722455550269043000",
	         "principalId": "AROAUF4S4NNXFP6WTHD73:aws-go-sdk-1722455550269043000",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-07-31T19:52:33Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "321848314756",
	               "arn": "arn:aws:iam::321848314756:role/stratus-red-team-get-usr-data-role",
	               "principalId": "AROAUF4S4NNXFP6WTHD73",
	               "type": "Role",
	               "userName": "stratus-red-team-get-usr-data-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   }
	]
    ```

[^1]: These logs have been gathered from a real detonation of this technique in a test environment using [Grimoire](https://github.com/DataDog/grimoire), and anonymized using [LogLicker](https://github.com/Permiso-io-tools/LogLicker).
