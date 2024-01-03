/**
 * @author alexandre.menezes
 * @email alexandre.menezes@everymind.com.br
 * @create date 2023-12-28 11:25:48
 * @modify date 2023-12-28 11:25:48
 * @desc [description]
 */
trigger AnalyzeCaseTrigger on Case (after insert) {
    new AnalyzeCase_TriggerHandler().run();
}