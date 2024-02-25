extern Image past_texture;
extern Image current_texture;
extern Image background_texture;

extern vec2 screen;
extern vec2 source;

float image_weight = 0.1f;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
    
    vec4 background_pixel = Texel(background_texture, texture_coords);

    vec2 tex_offset = 1.0/screen; //Get the Texel Size
    vec4 result = ((Texel(current_texture, vec2(texture_coords.x + tex_offset.x, texture_coords.y)) + //Pixel to the right
                   Texel(current_texture, vec2(texture_coords.x - tex_offset.x, texture_coords.y)) +  //Pixel to the left
                   Texel(current_texture, vec2(texture_coords.x, texture_coords.y - tex_offset.y)) +  //Pixel to the up
                   Texel(current_texture, vec2(texture_coords.x, texture_coords.y + tex_offset.y)))  //Pixel to the down
                   / 2.0) - Texel(past_texture, texture_coords);                                                      
    
    float distance = length(source - pixel_coords);
    if (distance < 10) {
        result = vec4(1.0, 1.0, 1.0, 1.0); //This value is the color of the "water"
    }
    
    return ((1 - image_weight) * result + (image_weight) * background_pixel);
}