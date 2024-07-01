// テクスチャとして設定した画像を柄として、頂点カラーをそのまま色に反映するテクスチャ

Shader "VertexColorShader"
{
    Properties
    {   
        _Tex ("Texture", 2D) = "white" {}       // 筆の質感を設定するテクスチャ    
    }
    CGINCLUDE

    sampler2D _Tex; 

    ENDCG
    SubShader
    {
        AlphaToMask On  // Alpha値をマスクとして利用
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            // #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;   // 頂点位置
                float2 uv : TEXCOORD0;      // UV
                float4 color : COLOR;       // 頂点カラー
            };
            
            struct v2f
            {
                float4 vertex : SV_POSITION;// ピクセル位置
                float2 uv : TEXCOORD0;      // UV
                float4 color : COLOR;       // ピクセルカラー
            };

            // 頂点シェーダー
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);      // 頂点位置からピクセル位置を算出
                o.color = v.color;  // 頂点カラーをそのまま利用
                o.uv = v.uv;        // UVをそのまま利用
                return o;
            }
            
            // フラグメントシェーダー
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_Tex, i.uv) * i.color;   // カラーを指定したテクスチャでマスク
                return col;
            }
            ENDCG
        }
    }
}
