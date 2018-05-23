trigger MaintenanceRequest on Case (before update, after update) {
    if(Trigger.isAfter) {
        MaintenanceRequestHelper.createNewMaintenanceRequest(Trigger.New, Trigger.newMap);
    }
}