initial begin
  Days days;
  days = new();

  days.choices = {Days::SUN, Days::SAT};
  `SV_RAND_CHECK(days.randomize());
  $display("Random weekend day %s\n", days.choice.name());

  days.choices = {Days::MON, Days::TUE, Days::WED, Days::THU, Days::FRI};
  `SV_RAND_CHECK(days.randomize());
  $display("Random week day %s", days.choice.name());
end
