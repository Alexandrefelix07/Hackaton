public without sharing class AnalyzeCase_TriggerHandler extends TriggerHandler {
    public List<Case> newCaseList;

    public AnalyzeCase_TriggerHandler() {
        this.newCaseList = (List<Case>) Trigger.new;
    }

    public override void afterInsert() {
        updateCaseAnalyzeCreate();
    }

    public override void  beforeInsert () {    
        
    }

    private void updateCaseAnalyzeCreate() {
        List<Case> caseToUpdate = new List<Case>();
        for (Case caseAnalyze : this.newCaseList) {   

                if (caseAnalyze.Origin == 'Email') {
                  String result = CaseCreator.analyzeEmail(caseAnalyze.Description);
                  caseAnalyze.Priority = result; // Aqui modificamos a prioridade com base no resultado da análise
                  caseToUpdate.add(caseAnalyze);
                }      
        }
        if (caseToUpdate.size() > 0) {
            Database.update(caseToUpdate);
        }
    }
}
