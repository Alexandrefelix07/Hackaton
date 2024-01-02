public with sharing class CaseCreator implements Queueable, Database.AllowsCallouts {
    private static final String ENDPOINT = 'https://generativelanguage.googleapis.com/v1beta2/models/';
    private static final String AUTHORIZATION_TOKEN = 'AIzaSyBFHmyRl8iJtQeHNYCu7qG7hZegCNO-prw'; 
    private static final String MODELID = 'gemini-pro';
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
        String url = ENDPOINT + MODELID + ':generateText?key=' + AUTHORIZATION_TOKEN;
        req.setEndpoint(url);
        req.setHeader('Content-Type', CONTENT_TYPE);
        req.setMethod(METHOD_TYPE); 
        req.setBody('{"prompt": {"text": "' + emailBody + '"}}');
        return req;
    }

    private void handleResponse(HTTPResponse res){
        if(res.getStatusCode() == 200){
            String response = res.getBody();
            System.debug('HTTP response: '+ response);
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            List<Map<String, Object>> candidates = (List<Map<String, Object>>) jsonResponse.get('candidates');
            String gptResponse = (String) candidates[0].get('output');
            System.debug('GptResponse: '+ response);   
        }
        else{
            System.debug('HTTP request failed with status code: '+ res.getStatusCode());
        }
    }
}

