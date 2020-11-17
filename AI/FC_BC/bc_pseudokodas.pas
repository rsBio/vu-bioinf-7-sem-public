boolean backward_chaining( tikslas ) {
    IF (tikslas patenka į visų tikslų sąrašą){                              //1
        RETURN FALSE; 
    }
    IF (tikslas patenka į pradinių faktų sąrašą) {                          //2
        RETURN TRUE; 
    }    
    IF (tikslas patenka į gautųjų faktų aibę) {                             //3
        RETURN TRUE;
    }
    tikslas pridedamas prie visų tikslų sąrašo;                             //4
    FOREACH (kiekvienai taisyklei iš taisyklių sąrašo) {                    //5
        IF (taisyklės konsekventas sutampa su duotu tikslu){                //6
        išsaugomi gautųjų ir produkcijų sąrašų dydžiai                      //7
        taisyklė_tinkama_taikyti = TRUE;                                    //8
        FOREACH (kiekvienam taisyklės kairės pusės faktui) {                //9 
            IF (backward_chaining( taisyklės kairės pusės faktas )) {       //10
                gautųjų faktų ir produkcijų sąrašai grąžinami į prieš rekursiją išsaugotas būsenas; 
                taisyklė_tinkama_taikyti = FALSE;
                BREAK;
            }
        } 
        IF (taisyklė_tinkama_taikyti) {
            taisyklės dešinioji pusė pridedama prie gautųjų faktų sąrašo;  	//11
            taisyklė pridedama prie produkcijų sąrašo;                      //12
            tikslas ištrinamas iš visų tikslų sąrašo;                       //13
            RETURN TRUE;
        }
    }
    RETURN FALSE;                                                           //14
}
