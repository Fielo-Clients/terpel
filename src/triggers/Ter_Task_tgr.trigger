trigger Ter_Task_tgr on Task (after delete, after insert, after update, before delete, before insert, before update) {

    Ter_Task_cls objTareas = new Ter_Task_cls();
    
    if(Trigger.isAfter)
    {
        
    }
    if(Trigger.isBefore)
    {

        if(Trigger.isUpdate)
        {
            objTareas.permisoModificar(Trigger.new);

        }
        if(Trigger.isDelete)
        {
            objTareas.permisoBorrar(Trigger.old);
        }
    }

}