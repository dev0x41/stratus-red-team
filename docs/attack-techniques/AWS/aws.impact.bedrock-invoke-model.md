---
title: Invoke Bedrock Model
---

# Invoke Bedrock Model


 <span class="smallcaps w3-badge w3-blue w3-round w3-text-white" title="This attack technique can be detonated multiple times">idempotent</span> 

Platform: AWS

## Mappings

- MITRE ATT&CK
    - Impact



## Description


Simulates an attacker enumerating Bedrock models and then invoking the Anthropic Claude 3 Sonnet (<code>anthropic.claude-3-sonnet-20240229-v1:0</code>) model to run inference using an arbitrary prompt. LLMjacking is an attack vector where attackers use stolen cloud credentials to run large language models, leading to unauthorized inference.

<span style="font-variant: small-caps;">Warm-up</span>: None.

<span style="font-variant: small-caps;">Detonation</span>: 

- If Anthropic Claude 3 Sonnet is not enabled, attempt to enable it using <code>PutUseCaseForModelAccess</code>, <code>ListFoundationModelAgreementOffers</code>, <code>CreateFoundationModelAgreement</code>, <code>PutFoundationModelEntitlement</code>
- Call <code>bedrock:InvokeModel</code> to run inference using the model.

References:

- https://permiso.io/blog/exploiting-hosted-models
- https://sysdig.com/blog/llmjacking-stolen-cloud-credentials-used-in-new-ai-attack/
- https://sysdig.com/blog/growing-dangers-of-llmjacking/
- https://www.lacework.com/blog/detecting-ai-resource-hijacking-with-composite-alerts
- https://reinforce.awsevents.com/content/dam/reinforce/2024/slides/TDR432_New-tactics-and-techniques-for-proactive-threat-detection.pdf

!!! note

	This technique attempts to enable and invoke the Bedrock model anthropic.claude-3-sonnet-20240229-v1:0. To do this, it creates a Bedrock use case request for Anthropic models with a fictitious company name, website and use-case:

	- Company Name: <code>test</code>
	- Company Website: <code>https://test.com</code>
	- Intended Users: <code>0</code>
	- Industry Option: <code>Government</code>
	- Use Cases: <code>None of the Above. test</code>


	It is expected that this will cause AWS to automatically send you an email entitled <code>You accepted an AWS Marketplace offer</code>. If you want to use a different Anthropic model, you can set the <code>STRATUS_RED_TEAM_BEDROCK_MODEL</code> environment variable to the model ID you want to use (see the list [here](https://docs.aws.amazon.com/bedrock/latest/userguide/model-ids.html)). Since the inputs to <code>InvokeModel</code> are model-specific, you can only specify an Anthropic model:

	- <code>anthropic.claude-v2</code>
	- <code>anthropic.claude-v2:1</code>
	- <code>anthropic.claude-3-sonnet-20240229-v1:0</code> (default)
	- <code>anthropic.claude-3-5-sonnet-20240620-v1:0</code>
	- <code>anthropic.claude-3-haiku-20240307-v1:0</code>
	- <code>anthropic.claude-instant-v1</code>


!!! note

	After enabling it, Stratus Red Team will not disable the Bedrock model.	While this should not incur any additional costs, you can disable the model by going to the [Model Access](https://us-east-1.console.aws.amazon.com/bedrock/home?region=us-east-1#/modelaccess) page in the AWS Management Console.


## Instructions

```bash title="Detonate with Stratus Red Team"
stratus detonate aws.impact.bedrock-invoke-model
```

## Detonation logs <span class="smallcaps w3-badge w3-light-green w3-round w3-text-sand">new!</span>

The following CloudTrail events are generated when this technique is detonated[^1]:


- `bedrock:CreateFoundationModelAgreement`

- `bedrock:GetFoundationModelAvailability`

- `bedrock:InvokeModel`

- `bedrock:ListFoundationModelAgreementOffers`

- `bedrock:PutFoundationModelEntitlement`

- `bedrock:PutUseCaseForModelAccess`


??? "View raw detonation logs"

    ```json hl_lines="6 53 96 141 186 231 276 321 366 411 458 503 548 593 638"

    [
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "4031b2d2-5e47-4d71-9eda-4f22702c45f3",
	      "eventName": "PutFoundationModelEntitlement",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:09:52Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": false,
	      "recipientAccountId": "494659789341",
	      "requestID": "ad8d9b62-bd64-4276-92bd-f8f6bc829370",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": {
	         "status": "SUCCESS"
	      },
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "8452e2fb-1252-460b-8f58-d3f5333c2630",
	      "eventName": "PutUseCaseForModelAccess",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:09:50Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": false,
	      "recipientAccountId": "494659789341",
	      "requestID": "94150f81-8f6e-45f2-80d8-7f229db388eb",
	      "requestParameters": null,
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "51d580ea-04f5-421c-b733-b5e4ec485a6e",
	      "eventName": "InvokeModel",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:11:24Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.10",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "021634af-f7c2-48a2-b140-98f50d47ede9",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock-runtime.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "f12a2c9b-72a6-4e05-976a-72febda6a8f4",
	      "eventName": "GetFoundationModelAvailability",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:11:22Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "ae609148-2602-4c22-bc7a-9ba0bec018db",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "efe53b88-f160-4734-bb93-7b87bbe44d53",
	      "eventName": "GetFoundationModelAvailability",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:11:12Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "65736802-5857-4ce4-b330-e00b6f49b1bd",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "89557ced-3487-49ac-8fdc-f6cccd4883e5",
	      "eventName": "GetFoundationModelAvailability",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:11:02Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "2c542cf0-623f-44b1-9286-d8737d57b1e8",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "148d06be-26df-4d27-aba4-5ef0d7df6587",
	      "eventName": "GetFoundationModelAvailability",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:10:42Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "582e088b-5c11-46cf-9b26-fe61e8ed5bac",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "61956b65-a857-4e46-8352-9c8506b52e73",
	      "eventName": "GetFoundationModelAvailability",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:10:32Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "fb9252f0-5112-4a6a-b751-cd22715bb8de",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "0a6c7fce-ffb0-47f6-b2e0-e3493c501567",
	      "eventName": "GetFoundationModelAvailability",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:10:12Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "6abb5c47-1aa4-4c51-929f-28ba9954870f",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "db9c43df-ae6f-4db3-8298-f5f779f74f4d",
	      "eventName": "CreateFoundationModelAgreement",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:09:51Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": false,
	      "recipientAccountId": "494659789341",
	      "requestID": "b133ab25-9785-491b-98bc-a5160e7c1b88",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1"
	      },
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "378c7831-cd5c-4967-a5a3-271b96087899",
	      "eventName": "ListFoundationModelAgreementOffers",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:09:50Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "7d83d020-f4a8-4643-85ac-259c3ee88f4c",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "b2038781-3ed7-43c7-ade7-358b162b2c41",
	      "eventName": "GetFoundationModelAvailability",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:09:50Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "1f64843b-c293-4910-9ae2-9b689cbd5fe6",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "876e6893-1f54-48dc-ab41-b0c307ac5021",
	      "eventName": "GetFoundationModelAvailability",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:10:52Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "8206559e-8c46-49e2-804d-ad3ece7a2072",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "4b478773-db64-45c1-a254-7da7bf6e3e5c",
	      "eventName": "GetFoundationModelAvailability",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:10:22Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "c16a2fba-5a33-4974-8629-0b96006e1596",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   },
	   {
	      "awsRegion": "megov-northeast-1r",
	      "eventCategory": "Management",
	      "eventID": "59b55742-0b37-4488-bb51-c54f8067758f",
	      "eventName": "GetFoundationModelAvailability",
	      "eventSource": "bedrock.amazonaws.com",
	      "eventTime": "2024-10-17T20:10:02Z",
	      "eventType": "AwsApiCall",
	      "eventVersion": "1.09",
	      "managementEvent": true,
	      "readOnly": true,
	      "recipientAccountId": "494659789341",
	      "requestID": "1a3157ce-20cf-47cd-8c00-389551d06231",
	      "requestParameters": {
	         "modelId": "anthropic.claude-3-sonnet-20240229-v1:0"
	      },
	      "responseElements": null,
	      "sourceIPAddress": "035.249.253.232",
	      "tlsDetails": {
	         "cipherSuite": "TLS_AES_128_GCM_SHA256",
	         "clientProvidedHostHeader": "bedrock.megov-northeast-1r.amazonaws.com",
	         "tlsVersion": "TLSv1.3"
	      },
	      "userAgent": "stratus-red-team_e0cb7ef1-0d48-463f-8988-277de94752b6",
	      "userIdentity": {
	         "accessKeyId": "ASIA6FTSFH98XNF7DFZB",
	         "accountId": "494659789341",
	         "arn": "arn:aws:sts::494659789341:assumed-role/test-role/cli",
	         "principalId": "AROA2N7TQQRGKJYPCLOG0:cli",
	         "sessionContext": {
	            "attributes": {
	               "creationDate": "2024-10-17T20:07:50Z",
	               "mfaAuthenticated": "false"
	            },
	            "sessionIssuer": {
	               "accountId": "494659789341",
	               "arn": "arn:aws:iam::494659789341:role/test-role",
	               "principalId": "AROA2N7TQQRGKJYPCLOG0",
	               "type": "Role",
	               "userName": "test-role"
	            }
	         },
	         "type": "AssumedRole"
	      }
	   }
	]
    ```

[^1]: These logs have been gathered from a real detonation of this technique in a test environment using [Grimoire](https://github.com/DataDog/grimoire), and anonymized using [LogLicker](https://github.com/Permiso-io-tools/LogLicker).
