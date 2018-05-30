public class BillingCalloutService {
    public static void callBillingService(List<Project__c> projects, Map<Id, Project__c> mProjects) {

        for(Project__c project : projects) {
            if(project.Status__c == 'Billable') {
                doCallout(project.ProjectRef__c, project.Billable_Amount__c);
            }
        }
    }

    @future(callout=true)
    private static void doCallout(String projectRef, Decimal amount) {
        Project__c billableProject = [Select Status__c,ProjectRef__c,Billable_Amount__c From Project__c Where ProjectRef__c =: projectRef];

        ServiceCredentials__c sc = ServiceCredentials__c.getValues('BillingServiceCredential');
        String response;
        BillingServiceProxy.Project projectDetails = new BillingServiceProxy.Project();
        projectDetails.username = sc.Username__c;
        projectDetails.password = sc.Password__c;
        projectDetails.projectRef = projectRef;
        projectDetails.billAmount = amount;
        BillingServiceProxy.InvoicesPortSoap11 invoices = new BillingServiceProxy.InvoicesPortSoap11();
        response = invoices.billProject(projectDetails);

        if(response != null && response.equalsIgnoreCase('OK')) {
            billableProject.Status__c = 'Billed';
            update billableProject;
        }
    }
}

