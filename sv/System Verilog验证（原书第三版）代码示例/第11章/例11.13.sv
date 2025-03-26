typedef struct packed {
  bit [3:0] GFC;
  bit [7:0] VPI;
  bit [15:0] VCI;
  bit CLP;
  bit [2:0] PT;
  bit [7:0] HEC;
  bit [0:47][7:0] Payload;
} uniType;
