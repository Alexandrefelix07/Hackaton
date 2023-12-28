public without sharing class AnalyzeCase_TriggerHandler extends TriggerHandler {
    public List<Case> newCaseList;

    public AnalyzeCase_TriggerHandler() {
        this.newCaseList = (List<Case>) Trigger.new;
    }

    public override void afterInsert() {
        updateCaseAnalyzeCreate();
    }

    private void updateCaseAnalyzeCreate() {
        List<Case> caseToUpdate = new List<Case>();
        for (Case caseAnalyze : this.newCaseList) {   
            //if (caseAnalyze.Origin == 'Email') {
            String emailBody = caseAnalyze.Description;
            System.enqueueJob(new CaseCreator(emailBody));                 
        }
    }
}
