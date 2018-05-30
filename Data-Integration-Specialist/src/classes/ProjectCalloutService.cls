public class ProjectCalloutService {
    @InvocableMethod(label='PostOpportunityToPMS' description='Posts Opportunities To PMS')
	public static void PostOpportunityToPMS(List<Id> oppId){
        Opportunity opp = [Select Id, Name, Account.Name, CloseDate, Amount, StageName From Opportunity Where Id =: oppId[0]];
        System.enqueueJob(new QueueablePMSCall(opp));
    }

    @TestVisible
    private class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        Opportunity opp;
        public QueueablePMSCall(Opportunity opp) {
            this.opp = opp;
        }

        public void execute(QueueableContext context) {
            ServiceTokens__c st = ServiceTokens__c.getValues('ProjectServiceToken');
            String token = st.Token__c;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndPoint('callout:ProjectService');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('token', token);
            request.setBody('{"opportunityId":'+opp.Id+'","opportunityName":'+opp.Name+'","accountName":'+opp.Account.Name+'","closeDate":'+opp.CloseDate+'","amount":'+opp.Amount+'" }');
            HttpResponse response = http.send(request);

            if(response.getStatusCode() !=201) {
                opp.StageName = 'Submitted Project';

            } else {
                opp.StageName = 'Resubmit Project';
            }
            update opp;
        }
    }
}