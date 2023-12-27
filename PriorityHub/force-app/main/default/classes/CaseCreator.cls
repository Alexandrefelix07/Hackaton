public class CaseCreator {
    private static final String ENDPOINT = 'https://your-instance.salesforce.com/services/data/v50.0/sobjects/Case';
    private static final String AUTHORIZATION = 'Bearer YOUR_ACCESS_TOKEN';
    
    public void createCase(String subject, String description, String priority) {
        HttpRequest req = buildHttpRequest(subject, description, priority);
        HttpResponse res = new Http().send(req);
        // Handle the response as needed.
    }

    private HttpRequest buildHttpRequest(String subject, String description, String priority) {
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', AUTHORIZATION);
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');
        req.setBody(buildCaseData(subject, description, priority));
        return req;
    }

    private String buildCaseData(String subject, String description, String priority) {
        Map<String, String> caseData = new Map<String, String>{
            'Subject' => subject,
            'Description' => description,
            'Priority' => priority
            // Add other relevant fields here.
        };
        return JSON.serialize(caseData);
    }
}
