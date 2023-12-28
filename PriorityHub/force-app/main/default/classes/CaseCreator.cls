
public with sharing class CaseCreator implements Queueable {
    private static final String ENDPOINT = 'https://api.openai.com';
    private static final String AUTHORIZATION_TOKEN = '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'; 
    private static final String CONTENT_TYPE = 'application/json';
    private static final String METHOD_TYPE = 'POST'; 
    private static final String PRIORITY = 'Medium';
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
        handleResponse(res);
    }

    private HttpRequest setupHttpRequest(String emailBody){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setHeader('Authorization', AUTHORIZATION_TOKEN); 
        req.setHeader('Content-Type', CONTENT_TYPE);
        req.setMethod(METHOD_TYPE); 
        req.setBody(emailBody);
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