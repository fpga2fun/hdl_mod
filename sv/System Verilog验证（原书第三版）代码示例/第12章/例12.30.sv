char *print(p_rgb rgb) {
 static char s[12];
 sprintf(s, "%02x,%02x,%02x", rgb->r, rgb->g, rgb->b);
 return s;
}