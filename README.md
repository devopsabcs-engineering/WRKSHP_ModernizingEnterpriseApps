# Delivery Guide: Workshop for Modernizing Enterprise Apps with App Platforms

This guide will provides details and instructions to help you deliver the **Workshop Plan** for your customer. This engagement must accomplish the following objectives:  

**Objectives**
- Identify and define the digital skills required for successful digital transformation 
- Establish a skilling plan to leverage customers persona 
- Enable key roles for addressing Cloud Challenges via new ways of working.

**Deliverable Standards**
- Education sessions for selected workshops containing instructor sessions with slides, demos, and hands on labs.

## Customer Participants

Having the right customer participants in the  workshop is essential to completing a successful engagement. Ensure the customer roles outlined below are available and able to participate in the workshop. 

|Customer Role | Description | Required or Optional|
|----|----|----|
|Maker | Anybody interested in development | Optional|
|Developer| People with experience in coding or advanced makers | Required|
|Architect| People with experience in designing and architecting solutions | Required|
|Lead Developer| Responsible for delivering and reviewing PoC, Code and Design | Required|
|DevOps/DevSecOps | Team responsible for deploying application to production| Optional*|
|Security Lead | Team responsible for security across all aspects of the application | Optional*| 
|IT Professionals| These are the people responsible for provisioning and managing IT resources like databases, networking, compute, IAM, Security, etc.  | Optional*|

> [!NOTE]
> One of these key resources maybe required. It is recommended to have at least one of them included in the conversation. For example, security and DevOps integration are integral part of modernizing any application development. So the people responsible for implementation should be included in the conversation to accelerate and facilitate the application modernization efforts.

## Delivery Guidance
This section includes all non-technical delivery guidance and supporting artifacts for workshop plan. You are free to adapt each step to meet your customers needs as long as you are able to meet the objectives and deliverable standards for next phase. 

### Step 1: Preparing for the delivery

- Ensure you have good understanding of workshop material, especially demos and labs.  
  They are critical for good student experience.
- Ensure right audience are present for the workshop.  
  Refer to [Customer Participants](#customer-participants) section for details.
- Ensure the pre-reqs for the workshop(s) are met.

### Step 2: Scoping

#### **Background**

Modernization is where you start capitalizing on the cloud. It's all about maximizing value and making the biggest impact with the least amount of effort. The result of modernization is an increase in operational efficiency. You can lower your management burdens and increase performance while minimizing cost. Less work and more productivity is how you rapidly meet and exceed objectives.

In the *Modernizing applications with data* Workshop plan, we'll focus on Modernizing an application in the cloud. Modernizing your applications can rapidly transform how people interact with your business or organization. The goal of application modernization is to enhance your applications to meet the needs of internal users and external customers. Adopting platform-as-a-service (PaaS) solutions lets you modernize any application or framework and enables your business to scale. 

#### **Scoping Guidance Agenda**

Explain how the delivery will be carried out. What they can expect at each phase, before and after delivery. Request customer that for the successful delivery who would you need. Refer to [Customer Participants](#customer-participants) section for details.

Ensure you discuss and understand the customer's requirements and tooling to be used (Azure DevOps or GitHub) is agreed for secure DevOps at a high level and review any customer document that will be used for VBD. Ensure all the stakeholders are on the same page regarding the deliverables - **not only what workshop would cover but also that it will not be a PoC**.

If customer is planning to use their own subscription(s) for labs then make sure that they have the required access to perform labs.

Use scoping call to understand what topics you may have to prepare / cover during the engagement, choose from the list below: 

## *Agenda*

### Day 1 
- Introduction to [Azure Compute and Networking](https://learn.microsoft.com/en-us/training/modules/describe-azure-compute-networking-services)
- Infrastructure as [Code with Bicep](https://learn.microsoft.com/en-us/training/modules/introduction-to-infrastructure-as-code-using-bicep/)
- Introduction to [Azure SQL](https://learn.microsoft.com/en-us/training/modules/azure-sql-intro)

### Day 2
- Building and [Deploying Web Applications](https://learn.microsoft.com/en-us/training/paths/create-azure-app-service-web-apps)
- Migrating on-premises to [Azure App Service](https://learn.microsoft.com/en-us/training/modules/move-web-application-to-app-services/)
- Implementing [DevOps practices in PaaS](https://learn.microsoft.com/en-us/training/browse/?terms=devops&roles=developer)

### Day 3
- Managing [Identities and Access in Azure](https://learn.microsoft.com/en-us/training/paths/az-204-implement-authentication-authorization)
- Adding [Search capabilities to Applications](https://learn.microsoft.com/en-us/training/modules/implement-advanced-search-features-azure-cognitive-search)




#### Additional Relavent MS Learn Modules:

| Topic                       | Description                                   | Links                                                                                      |
|-----------------------------|-----------------------------------------------|--------------------------------------------------------------------------------------------|
| Azure Overview              | Introduction to Azure Compute and Networking | [Azure Fundamentals](https://learn.microsoft.com/en-us/training/paths/microsoft-azure-fundamentals-describe-cloud-concepts/) , [Azure compute and networking services](https://learn.microsoft.com/en-us/training/modules/describe-azure-compute-networking-services/)               |
| Bicep Templates             | Infrastructure as Code with Bicep            | [Introduction to Bicep](https://learn.microsoft.com/en-us/training/modules/introduction-to-infrastructure-as-code-using-bicep/)                  |
| Web Apps                    | Building and deploying web applications       | [Implement Azure App Service web apps](https://learn.microsoft.com/en-us/training/paths/create-azure-app-service-web-apps/)  |
| Azure SQL                   | Introduction to Azure SQL      | [Azure SQL Fundamentals](https://learn.microsoft.com/en-us/training/modules/azure-sql-intro/)          |
| On Prem to Azure            | Migrating on-premises to Azure App Service| [Migrate a web app to Azure App Service](https://learn.microsoft.com/en-us/training/modules/move-web-application-to-app-services/)   |
| Cosmos DB                   | Globally distributed NoSQL database service   | [Develop solutions that use Azure Cosmos DB](https://learn.microsoft.com/en-us/training/paths/az-204-develop-solutions-that-use-azure-cosmos-db/) |
| Identity                    | Managing identities and access in Azure       | [Implement user authentication and authorization](https://learn.microsoft.com/en-us/training/paths/az-204-implement-authentication-authorization/) |
| Azure Search                | Adding search capabilities to applications   | [Implement advanced search features in Azure AI Search](https://learn.microsoft.com/en-us/training/modules/implement-advanced-search-features-azure-cognitive-search/)    |
| DevOps in PaaS              | Implementing DevOps practices in PaaS         | [Multiple](https://learn.microsoft.com/en-us/training/browse/?terms=devops&roles=developer)  |
| Web/Serverless              | Serverless computing and API management      | [Multiple](https://learn.microsoft.com/en-us/training/browse/?terms=serverless&roles=developer)             |
| Monitoring                  | Monitoring and diagnostics tools in Azure     | [Configure monitoring for applications](https://learn.microsoft.com/en-us/training/modules/configure-monitoring-applications/),  [Implement observability in a cloud-native .NET 8 application with OpenTelemetry](https://learn.microsoft.com/en-us/training/modules/implement-observability-cloud-native-app-with-opentelemetry/)    |
| High throughput             | Scalable messaging and data streaming         | [Architect message brokering and serverless applications in Azure](https://learn.microsoft.com/en-us/training/paths/architect-messaging-serverless/) |


> [!IMPORTANT]
> The topics for the workshop delivery may change as Azure platform is changing everyday.
> Please refer to the respective VBD resources for up to date list of contents.

Some example questions you may ask during the scoping are:

- What do you expect from the delivery?
- What technical / business problem are you expecting the workshop to solve?
- What topic areas interest the within secure DevOps PoC that is most relevant to the team?
- What are the skill levels of the developers, operation and security teams?

> [!NOTE]
> If you pick more than one VBD IP, the total Workshop duration will increase by 3 days for each additional IP (**Total days = 3 x # IPs**).
> Most VBD IPs are between 2-4 days. Remember to update the duration as needed.

### Step 3: Kickoff

Share details of what workshop(s) would cover and what will not be covered. If a specific topic of interest is not covered then you should have already thought about handling it during or after scoping.

### Step 4: Delivery

Ensure you cover modules that are relevant to or identified for the success of VBD.

### Step 5: Customer close out

If needed send follow up materials / resources to the attendees. Ensure that the customer understands what the next steps are after the workshop(s). You need to understand basics of VBD and tell them what they can expect next.

## Resources, Readiness and References

- [Migrate or modernize first?](https://learn.microsoft.com/azure/cloud-adoption-framework/adopt/migrate-or-modernize)
- [Modernize any application in the cloud](https://learn.microsoft.com/azure/cloud-adoption-framework/modernize/modernize-strategies/application-modernization)
- [Develop digital inventions in Azure](https://learn.microsoft.com/azure/cloud-adoption-framework/innovate/best-practices)
- [Web applications architecture design](https://learn.microsoft.com/azure/architecture/guide/web/web-start-here#modernization)
- [Choose between traditional web apps and single-page apps](https://learn.microsoft.com/dotnet/architecture/modern-web-apps-azure/choose-between-traditional-web-and-single-page-apps)
- [ASP.NET architectural principles](https://learn.microsoft.com/dotnet/architecture/modern-web-apps-azure/architectural-principles)
- [Common client-side web technologies](https://learn.microsoft.com/dotnet/architecture/modern-web-apps-azure/common-client-side-web-technologies)
- [Development process for Azure](https://learn.microsoft.com/dotnet/architecture/modern-web-apps-azure/development-process-for-azure)
- [Azure hosting recommendations for ASP.NET Core web apps](https://learn.microsoft.com/dotnet/architecture/modern-web-apps-azure/azure-hosting-recommendations-for-asp-net-web-apps)
- [Reliable web app pattern planning (.NET)](https://aka.ms/eap/rwa/dotnet/doc)