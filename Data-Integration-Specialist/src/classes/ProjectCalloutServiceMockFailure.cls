global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
    Opportunity opp;
    public ProjectCalloutServiceMockFailure(Opportunity opp) {
        this.opp = opp;
    }

  global HTTPResponse respond(HttpRequest request) {
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type', 'application/json'); 
      response.setBody('{"opportunityId":'+opp.Id+'","opportunityName":'+opp.Name+'","accountName":'+opp.Account.Name+'","closeDate":'+opp.CloseDate+'","amount":'+opp.Amount+'" }');
      response.setStatusCode(201);
      return response;
  }
}