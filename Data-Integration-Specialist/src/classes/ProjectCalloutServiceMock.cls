global class ProjectCalloutServiceMock implements HttpCalloutMock {
    Opportunity opp;
    public ProjectCalloutServiceMock(Opportunity opp) {
        this.opp = opp;
    }

  global HTTPResponse respond(HttpRequest request) {
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type', 'application/json'); 
      response.setBody('{"opportunityId":'+opp.Id+'","opportunityName":'+opp.Name+'","accountName":'+opp.Account.Name+'","closeDate":'+opp.CloseDate+'","amount":'+opp.Amount+'" }');
      response.setStatusCode(200);
      return response;
  }
}