#version 110

#ifdef VERTEX_SHADER
uniform mat4 ProjectionMatrix;

attribute vec2 InPosition;
attribute vec4 InColor;
attribute vec2 InTexCoord;

varying vec4 Color;
varying vec2 TexCoord;

void main( void )
{
	gl_Position = ProjectionMatrix * vec4( InPosition, 0.0, 1.0 );
	Color = InColor;
	TexCoord = InTexCoord;
}
#endif

#ifdef FRAGMENT_SHADER
uniform sampler2D ColorMap;
uniform vec4      ColorMapSize;
uniform float     ColorMapWidth;
uniform float     ColorMapHeight;

uniform vec4  SpriteBorder;
uniform float TimeGame;

varying vec4 Color;
varying vec2 TexCoord;

vec4 border = SpriteBorder;
bool borderSwapped = false;

bool CheckPixel( float x, float y )
{
	bool result = false;
	if( texture2D( ColorMap, vec2( x, y ) ).a > 0.0 )
	{
		gl_FragColor = Color;
		if( gl_FragColor.a > 0.0 )
		{
			float v = ( TexCoord.y - border.y ) / ( border.w - border.y );
			if( !borderSwapped )
				v += 1.0 - mod( TimeGame, 2.0 );
			else
				v += -1.0 + mod( TimeGame, 2.0 );
			if( v > 1.0 )
				v = 2.0 - v;
			else if( v < 0.0 )
				v = -v;
			gl_FragColor.rgb += v * 0.60 - 0.30;
			gl_FragColor.rgb = clamp( gl_FragColor.rgb, 0.0, 1.0 );
		}
		else
		{
			gl_FragColor.a = 1.0;
		}
		result = true;
	}
	return result;
}

void main( void )
{
	gl_FragColor = vec4( 0.0 );
	
	float l = TexCoord.x - ColorMapSize.z;
	float t = TexCoord.y - ColorMapSize.w;
	float r = TexCoord.x + ColorMapSize.z;
	float b = TexCoord.y + ColorMapSize.w;
	
	if( border.w < border.y )
	{
		border.yw = border.wy;
		borderSwapped = true;
	}
	
	if( l < border.x )
		CheckPixel( r, TexCoord.y );
	else if( r > border.z )
		CheckPixel( l, TexCoord.y );
	else if( t < border.y )
		CheckPixel( TexCoord.x, b );
	else if( b > border.w )
		CheckPixel( TexCoord.x, t );
	else if( texture2D( ColorMap, TexCoord ).a == 0.0 )
	{
		CheckPixel( l, TexCoord.y ) ||
		CheckPixel( r, TexCoord.y ) ||
		CheckPixel( TexCoord.x, t ) ||
		CheckPixel( TexCoord.x, b );
	}
	
	if( gl_FragColor.a == 0.0 )
		discard;
}
#endif
