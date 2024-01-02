public with sharing class CaseCreator implements Queueable, Database.AllowsCallouts {
    private static final String ENDPOINT = 'https://generativelanguage.googleapis.com/v1beta/models/';
    private static final String AUTHORIZATION_TOKEN = 'AIzaSyBFHmyRl8iJtQeHNYCu7qG7hZegCNO-prw'; 
    private static final String MODEL_ID = 'gemini-pro';
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
        HttpResponse res = http.send(req);
        handleResponse(res);
    }

    private HttpRequest setupHttpRequest(String emailBody) {
        HttpRequest req = new HttpRequest();
        String url = ENDPOINT + MODEL_ID + ':generateContent?key=' + AUTHORIZATION_TOKEN;
    
        req.setEndpoint(url);
        req.setHeader('Content-Type', CONTENT_TYPE);
        req.setMethod(METHOD_TYPE);
    
        String requestBody = '{"contents": [{"parts":[{"text": "' + emailBody + '"}]}]}';
        req.setBody(requestBody);
    
        System.debug('GPT Request Body: ' + requestBody); 
        return req;
    }

    private void handleResponse(HttpResponse res) {
        System.debug('GptResponse: ' + res); 
        if (res.getStatusCode() == 200) {
            String response = res.getBody();
            System.debug('GptResponse: ' + response);   
        } else {
            System.debug('HTTP request failed with status code: ' + res.getStatusCode());
        }
    }
}
