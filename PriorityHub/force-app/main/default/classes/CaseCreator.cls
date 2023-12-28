public with sharing class CaseCreator {
    private static final String ENDPOINT = 'https://api.openai.com';
    private static final String AUTHORIZATION_TOKEN = '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'; 
    private static final String CONTENT_TYPE = 'application/json';
    private static final String METHOD_TYPE = 'POST'; 
    private static final String PRIORITY = 'Medium';

    public static String analyzeEmail(String emailBody) {

        HttpRequest req = setupHttpRequest(emailBody);
        Http http = new Http();
        HTTPResponse res = executeHttpRequest(http, req);
        handleResponse(res);
        return determinePriority();
    }
    
    private static HttpRequest setupHttpRequest(String emailBody){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setHeader('Authorization', AUTHORIZATION_TOKEN); 
        req.setHeader('Content-Type', CONTENT_TYPE);
        req.setMethod(METHOD_TYPE); 
        req.setBody(emailBody);
        return req;
    }
    
    private static HTTPResponse executeHttpRequest(Http http, HttpRequest req){
        return http.send(req);
    }
    
    private static void handleResponse(HTTPResponse res){
        if(res.getStatusCode() == 200){
            String response = res.getBody();
            //logica para tratar o retorno do GPT caso for prioridade 

        }
        else{
            System.debug('HTTP request failed with status code: '+ res.getStatusCode());
        }
    }
    
    private static String determinePriority(){
        return PRIORITY;
    }
}
