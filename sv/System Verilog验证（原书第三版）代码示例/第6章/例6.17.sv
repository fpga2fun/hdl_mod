class Days;
  typedef enum {
    SUN,
    MON,
    TUE,
    WED,
    THU,
    FRI,
    SAT
  } days_e;
  days_e choices[$];
  rand days_e choice;
  constraint cday {choice inside choices;}
endclass
