public with sharing class CaseCreator implements Queueable, Database.AllowsCallouts {
    private static final String ENDPOINT = 'https://generativelanguage.googleapis.com/v1/models/';
    private static final String AUTHORIZATION_TOKEN = 'AIzaSyBFHmyRl8iJtQeHNYCu7qG7hZegCNO-prw'; 
    private static final String MODEL_ID = 'gemini-pro';
    private static final String CONTENT_TYPE = 'application/json';
    private static final String METHOD_TYPE = 'POST'; 
    private static final Integer RATE_LIMIT = 60;
      
    private Id caseId;

    public CaseCreator(Id caseId) {
        this.caseId = caseId;
    }

    public void execute(QueueableContext context) {
        // if (isRateLimitExceeded()) {
        //     // Não execute a chamada se o limite de taxa for excedido
        //     System.debug('Limite de taxa excedido. Consulta não realizada.');
        //     return;
        // }
        analyzeCase(caseId);
        //updateRateLimit();
    }

    
    // private Boolean isRateLimitExceeded() {
    //     DateTime oneMinuteAgo = DateTime.now().addMinutes(-1);
    //     Integer calloutCount = [SELECT COUNT() FROM Rate_Limit_Log__c WHERE Timestamp__c >= :oneMinuteAgo];
    //     return calloutCount >= RATE_LIMIT;
    // }

    // private void updateRateLimit() {
    //     // Cria um novo registro no log de controle de taxa
    //     insert new Rate_Limit_Log__c(Timestamp__c = DateTime.now());
    // }


    private void analyzeCase(Id caseId) {
        Case caseToAnalyze = [SELECT Id, Description FROM Case WHERE Id = :caseId LIMIT 1];
        HttpRequest req = setupHttpRequest(caseToAnalyze.Description);
        Http http = new Http();
        HttpResponse res = http.send(req);
        handleResponse(res, caseToAnalyze);
    }

    private HttpRequest setupHttpRequest(String emailBody) {
        HttpRequest req = new HttpRequest();
        String url = ENDPOINT + MODEL_ID + ':generateContent?key=' + AUTHORIZATION_TOKEN;

        req.setEndpoint(url);
        req.setHeader('Content-Type', CONTENT_TYPE);
        req.setMethod(METHOD_TYPE);

        String requestBody = '{"contents": [{"parts":[{"text": " analisar e determinar se o caso deve ser urgente em poucas palavras : ' + emailBody + '"}]}]}';
        req.setBody(requestBody);

        System.debug('GPT Request Body: ' + requestBody); 
        return req;
    }


    private void handleResponse(HttpResponse res, Case caseToAnalyze) {
        if (res.getStatusCode() == 200) {
            String response = res.getBody();
            Boolean isUrgent = parseResponseAndDetermineUrgency(response);
            System.debug('GptResponse: ' + response);
            if (isUrgent) {
                // Atualizar o caso para o status "Urgente"
                updateCaseToUrgent(caseToAnalyze);
                //respondToCaseByEmail(caseToAnalyze);
            }

        } else {
            System.debug('HTTP request failed with status code: ' + res.getStatusCode());
        }
    }

    private Boolean parseResponseAndDetermineUrgency(String response) {
        // Lógica para determinar se o caso deve ser urgente
        return response.toLowerCase().contains('urgente');
    }

    private void updateCaseToUrgent(Case caseToUpdate) {
        // Atualizar o status do caso para "Urgente"
        caseToUpdate.Priority = 'High';

        try {
            // Use Database.update com o parâmetro allOrNone definido como false
            Database.update(caseToUpdate, false);
        } catch (Exception e) {
            System.debug('Erro ao atualizar caso para urgente: ' + e.getMessage());
        }
    }

    private void respondToCaseByEmail(Case caseToRespond) {
        String emailSubject = 'Resposta ao Caso ' + caseToRespond.CaseNumber;
        String emailBody = 'Seu caso é urgente. Aqui estão algumas instruções adicionais...'; // Adicione o corpo do e-mail conforme necessário

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{caseToRespond.ContactEmail});
        email.setSubject(emailSubject);
        email.setPlainTextBody(emailBody);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
        
}