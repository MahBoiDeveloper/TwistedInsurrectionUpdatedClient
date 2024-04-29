//Before/After based shader for isolating the C&C engine sidebar.
//Author: tomsons26
//Edited by: AutoGavy
//To use place UI_Before before your effects, enable it, place UI_After after your effects, enable it

#include "ReShade.fxh"
#include "ReShadeUI.fxh"

uniform bool Isolate_UI <
> = true;

texture UI_Before { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
sampler UI_Before_sampler { Texture = UI_Before; };

float4 PS_UI_Before(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
    return tex2D(ReShade::BackBuffer, texcoord);
}

float4 PS_UI_After(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
    if (Isolate_UI) {
        float2 viewport;
        viewport.x = (BUFFER_WIDTH - 168) * ReShade::PixelSize.x;
        viewport.y = 16 * ReShade::PixelSize.y;
        if (texcoord.x > viewport.x || texcoord.y < viewport.y) {
            return tex2D(UI_Before_sampler, texcoord);
        }
    }
    //effect not enabled, return the before
    return tex2D(ReShade::BackBuffer, texcoord);
    
}

technique UI_Before
{
    pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_UI_Before;
        RenderTarget = UI_Before;
    }
}

technique UI_After
{
    pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_UI_After;
    }
}