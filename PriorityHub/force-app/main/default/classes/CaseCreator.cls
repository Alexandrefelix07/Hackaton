public with sharing class CaseCreator implements Queueable, Database.AllowsCallouts {
    private static final String ENDPOINT = 'https://api.openai.com/v1/engines/davinci/completions';
    private static final String AUTHORIZATION_TOKEN = 'Bearer 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'; 
    private static final String CONTENT_TYPE = 'application/json';
    private static final String METHOD_TYPE = 'POST'; 
    private String emailBody;

    public CaseCreator(String emailBody) {
        this.emailBody = emailBody;
    }

    public void execute(QueueableContext context) {
        analyzeEmail(emailBody);
    }

    private void analyzeEmail(String emailBody) {
        HttpRequest req = setupHttpRequest(emailBody);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        handleResponse(res);
    }

    private HttpRequest setupHttpRequest(String emailBody){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setHeader('Authorization', AUTHORIZATION_TOKEN); 
        req.setHeader('Content-Type', CONTENT_TYPE);
        req.setMethod(METHOD_TYPE); 
        String requestBody = '{"prompt": "' + emailBody + '"}';
        req.setBody(requestBody);
        return req;
    }

    private void handleResponse(HTTPResponse res){
        if(res.getStatusCode() == 200){
            String response = res.getBody();
            System.debug('HTTP response: '+ response);
        }
        else{
            System.debug('HTTP request failed with status code: '+ res.getStatusCode());
        }
    }
}

