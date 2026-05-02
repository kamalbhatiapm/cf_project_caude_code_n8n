## Defining key performance indicators (KPIs) for AI Agents

#### **Objective:** 

Last week, we narrowed the scope of our agent and came up with a roadmap that allowed us to iterate fast, give continuous value and validate key assumptions. Now, setting metrics that allow you to track the progress of your agent becomes important. 

####  **Context:** 

Ok, by now we understand what it takes to build an AI agent such that you give them a goal (get key terms from contract and insert in hubspot), use knowledge (docs)  and signal (Current state of world)  with reasoning (LLM)  to create plans to change the state of world with actions(tools, API’s), steps to validate if progress is made and on each halt come up with recovery plan.

Further, they can have persistent and runtime memory,  and can call humans to clarify.  
With all this system for the first time we can set up north star metrics that are outcome based and then set L1 metrics that our north star metrics depend upon. 

#### **KPIs for Agents**

**North star metrics: Track long term goals for your mission.** 

- Total no. of task completed (WoW) 

**L1 Metrics : Primary metrics that contributes directly to your North star metrics** 

* **% Task completion rate per user :** No of tasks completed without human intervention or minimum intervention and high quality per user. (WoW)  
* **% Helpfulness :** This metric tracks a lot of smaller signals to gauge the response quality of intermittent steps and the final outcome of your agent.  
* **% Honest :** This metric tracks how much information that your agent presented or used is actually verifiable, factful and grounded in reality.   
* **% Harmless (guardrails adhered)** : This tracks how many conversations erode trust for your customers. This can mean not adhering to compliance requirement, your internal policy or simple doing things that   
* **NPS/User feedback rating :** This is the same metrics as before that tracks how happy are your customers and uses them as proxy metrics. Proxy metrics means that as you automate tasks user satisfaction should not drop.

**L2 Metrics :**

- **% Helpfulness**  
  - correctness of issue/goal identification,   
  - plan accuracy,   
  - succinct/format responses  
  - Instruction adherence   
  - % abandon rate without accomplishing goals  
    - Conversation halted after maximum no. of attempt reached  
    - Conversation where a human was called to get help   
- **% Honest**   
  - grounding/extraction accuracy,   
  - Factfulness : Whatever the agent says/does is grounded in reality.  
  - Grounded with less top two sources.  
  - Reasoning or planning step accuracy    
  - Is the output produced in desired format (for example, Json,CSV)  
- **% Harmless (guardrails , policy and compliance adhered)**   
  - No insult, threat or profanity.   
  - No bad mouthing competitors   
  - No way to make it say whatever the user wants.   
  - No. of nonfactual information shared  
- **Total cost of task execution reduction rate (MoM)**: The reduction in cost incurred on cloud/AI infrastructure for executing each individual task as well as for completing the entire job.  
- **Avg. no of tokens consumed per task**: The average number of tokens used per task, which can help in assessing processing cost and efficiency.  
- **Avg. no. of calls to get a task done :** This is the average no. of calls your solution makes to LLMs to achieve the desired results   
- **Cycle time reduction rate (MoM) :** Time it takes to complete a task.   
  - **Latency First meaningful response (p99, p95)**: The time taken to generate the first meaningful response, measured at the 99th and 95th percentiles to capture both typical and outlier performance.

**Other imp. Quality metrics:** 

- **Latency per unit (risk/contract term) returned**: The response latency calculated per unit of output, such as for finding risk in contract you can measure latency of each term that was evaluated for risk analysis.   
- **No. of interaction handled per minute**: The number of interactions or transactions that the system can process per minute, indicating overall throughput capacity.  
- **Recovery rate:** The rate at which the system successfully recovers from failures or errors, ensuring resilience and continuous operation.   
- **Uptime**: Measure time that your agent was up and running without any blocking issues. 

**Finally** 🎉

Now we know what metrics you can set up SMART (Specific, Measurable, Achievable, Relevant, Time-bound). goals for your teams. 

**Example of goals for AI specific products** 

| SMART Criteria | Area | Dependent Metrics | Target |
| ----- | ----- | ----- | ----- |
| **Increase Total no. of tasks completed  20% MOM** | Business impact  |  Active User Rate | 100k by March 2026 |
| **Increase helpfulness by 40% within 6 months** | Accuracy | 1\. Step-level accuracy (correct actions per workflow stage) 2\. Precision/recall ratio (relevant vs. total actions) | 95% accuracy 0.9 F1-score |
| **Cut average handling time by 30% by Q3 2025** | Operational Efficiency | 1\. Response time per task stage 2\. Automation rate (% tasks needing no human input) | \<2 min/task 85% automation |
| **Achieve 4.5/5 user rating across all interfaces by EOY** | User Satisfaction | 1\. Net Promoter Score (NPS) 2\. Sentiment analysis score | 4.7/5 85% positive |
| **Demonstrate 20% cost reduction in target processes** | Business Impact | 1\. Cost per resolved task 2\. Revenue influenced/retained | $5/task 15% uplift |
| **Maintain 99.9% uptime with zero data breaches** | Security/Stability | 1\. Threat detection rate 2\. Execution error rate | 98% \<1% errors |

#### **© All rights reserved Mahesh Yadav Institute, No part of this course can be reproduced, distributed, or transmitted in any form or by any means, including photocopying, recording, or other electronic or mechanical methods.**