//////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Package that defines the abstract base class and defines the header, data,
//          packet and bad packets.  
//          Chap_8_Advanced_OOP_and_Testbench_Guidelines/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: packet_pkg.sv,v $
// Revision 1.2  2011/11/16 11:46:04  tumbush.tumbush
// Use pkt.header.source_ip_address[15:0] in calc_header_checksum.
//
// Revision 1.1  2011/05/29 19:16:11  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/29 19:28:36  Greg
// Initial check-in
//
//////////////////////////////////////////////////////////////////////////////////////////

package packet_pkg;
   
      // List the length of each header field
   localparam VERSION_LENGTH = 4;
   localparam IHL_LENGTH = 4;
   localparam TYPE_OF_SERVICE = 8;
   localparam TOTAL_LENGTH_LENGTH = 16;
   localparam IDENTIFICATION_LENGTH = 16;
   localparam FLAGS_LENGTH = 3;
   localparam FRAGMENT_OFFSET_LENGTH = 13; 
   localparam TIME_TO_LIVE_LENGTH = 8;
   localparam PROTOCOL_LENGTH = 8;
   localparam HEADER_CHECKSUM_LENGTH = 16; 
   localparam SOURCE_IP_ADDRESS_LENGTH = 32;
   localparam DESTINATION_IP_ADDRESS_LENGTH = 32;
   
   // List default values for header
   localparam VERSION = 4; // IPV4
   localparam IHL = 5; // header is 5 32-bit words.

   // For this homework, limit the data size to 64-bits (8 octets).
   localparam DATA_LENGTH = 64;

   // Since header is 5 32-bit words (20 octets) and the
   // data is limited to 8 octets total length is 28;
   localparam TOTAL_LENGTH = (IHL*4)+DATA_LENGTH/8;
   
   // Header class to contain all the header fields.
class header_class;
   bit[VERSION_LENGTH-1:0] version = VERSION;
   bit [IHL_LENGTH-1:0]    ihl = IHL;                   
   rand bit[TYPE_OF_SERVICE-1:0] type_of_service;       
   bit[TOTAL_LENGTH_LENGTH-1:0] total_length = TOTAL_LENGTH;                 
   rand bit[IDENTIFICATION_LENGTH-1:0] identification;         
   rand bit[FLAGS_LENGTH-1:0] 	   flags;                 
   rand bit[FRAGMENT_OFFSET_LENGTH-1:0] fragment_offset;       
   rand bit[TIME_TO_LIVE_LENGTH-1:0]    time_to_live;          
   rand bit[PROTOCOL_LENGTH-1:0] 	    protocol;              
   bit [HEADER_CHECKSUM_LENGTH-1:0] header_checksum;       
   rand bit[SOURCE_IP_ADDRESS_LENGTH-1:0] source_ip_address;     
   rand bit[DESTINATION_IP_ADDRESS_LENGTH-1:0] destination_ip_address;
endclass // Header

   // Data class to contain the payload.
class data_class;
   rand bit [DATA_LENGTH-1:0] payload;
endclass // data

   // Abstract Base class for the packet
    // This is provided in the homework
   virtual 			    class base_packet;
      rand header_class header;
      rand data_class data;
      
      static int 		    count; // Number of instance created
      int 			    id; // Unique transaction id

      function new();
	 id = count++; // Give each object a unique ID
	 header = new();
	 data = new();
      endfunction // new
      
      pure virtual function base_packet copy();
   pure virtual function void display();
   pure virtual function void calc_header_checksum();
endclass
   
   // The packet class is constructed from a header and data
   // and inherits from the base packet class.
   // Must implement copy, display, and calc_header_checksum
   // because these functions are pure virtual in the base packet class.
class packet extends base_packet;

   virtual 			    function base_packet copy();
      packet pkt;
      pkt = new();
      pkt.header.version = header.version;
      pkt.header.ihl = header.ihl;                   
      pkt.header.type_of_service = header.type_of_service;       
      pkt.header.total_length = header.total_length;                 
      pkt.header.identification = header.identification;         
      pkt.header.flags = header.flags;                 
      pkt.header.fragment_offset = header.fragment_offset;       
      pkt.header.time_to_live = header.time_to_live;          
      pkt.header.protocol = header.protocol;              
      pkt.header.header_checksum = header.header_checksum;       
      pkt.header.source_ip_address = header.source_ip_address;     
      pkt.header.destination_ip_address = header.destination_ip_address;
      return pkt;
   endfunction // Transaction

   virtual 			    function void display();
      $display("%0t: ----- Header Data ----", $time);
      $display("version = 0x%0h", header.version);
      $display("ihl = 0x%0h", header.ihl);                   
      $display("type_of_service = 0x%0h", header.type_of_service);       
      $display("total_length = 0x%0h", header.total_length);                 
      $display("identification = 0x%0h", header.identification);         
      $display("flags = 0x%0h", header.flags);                 
      $display("fragment_offset = 0x%0h", header.fragment_offset);       
      $display("time_to_live = 0x%0h", header.   time_to_live);          
      $display("protocol = 0x%0h", header.protocol);              
      $display("header_checksum = 0x%0h", header.header_checksum);       
      $display("source_ip_address = 0x%0h", header.source_ip_address);     
      $display("destination_ip_address = 0x%0h", header.destination_ip_address);
      $display("data = 0x%0h", data.payload);
   endfunction
   
   virtual 			    function void calc_header_checksum();
      header.header_checksum = {header.version, header.ihl, header.type_of_service} ^ 
			       header.total_length  ^ header.identification ^ 
			       {header.flags, header.fragment_offset} ^ {header.time_to_live, header.protocol} ^ 
			       header.source_ip_address[31:16] ^ header.source_ip_address[15:0] ^
			       header.destination_ip_address[31:16] ^ header.destination_ip_address[15:0];
   endfunction
   

endclass // packet
   
// Create a bad packet class that inherits from the packet class
   // and will corrupt the Header Checksum of 2% of packets.
class bad_packet extends packet;
   rand bit bad_header_checksum; // Flag to generate a bad crc
   function new();
      super.new();
      id = count++; // Give each object a unique ID
   endfunction // new

   virtual 			    function base_packet copy();
      bad_packet bad;
      bad = new();
      bad.header.version = header.version;
      bad.header.ihl = header.ihl;                   
      bad.header.type_of_service = header.type_of_service;       
      bad.header.total_length = header.total_length;                 
      bad.header.identification = header.identification;         
      bad.header.flags = header.flags;                 
      bad.header.fragment_offset = header.fragment_offset;       
      bad.header.time_to_live = header.time_to_live;          
      bad.header.protocol = header.protocol;              
      bad.header.header_checksum = header.header_checksum;       
      bad.header.source_ip_address = header.source_ip_address;     
      bad.header.destination_ip_address = header.destination_ip_address;
      bad.bad_header_checksum = bad_header_checksum;
      return bad;
   endfunction // Transaction
   
   virtual 			    function void calc_header_checksum();
      super.calc_header_checksum();      // to get correct result
      if ($urandom_range(0,49) == 49) begin
	 header.header_checksum = ~header.header_checksum; // guarantees incorrect results
	 //$display("Corrupted header checksum");
      end 
   endfunction

endclass

endpackage // packet_pkg
   
