#region Type
enum uiType {
    PANEL,              // Done              000            Allows you to create panel, which contains anything else, (NonFixed)and allows you to drag panel around
    GROUP,              // Done              001            Allows you to create group, which contains anything else, and can be closed or opened
                                                            
    TEXT,               // Done              002            Allows you to text
    SPRITE,             // Done              003            Allows you to sprite
    SEPARATOR,          //                   004            Allows you to separator
                                                            
    FLOAT,              // Done              005            Allows you to 
    FLOAT2,             //                   006            Allows you to 
    FLOAT3,             //                   007            Allows you to 
    FLOAT4,             //                   008            Allows you to 
                                                            
    INT,                // Done              009            Allows you to 
    INT2,               //                   010            Allows you to 
    INT3,               //                   011            Allows you to 
    INT4,               //                   012            Allows you to 
                                                            
    RADIOBUTTONSPACE,   // Done              013            Allows you to 
    RADIOBUTTON,        // Done              014            Allows you to 
    BUTTON,             // Done              015            Allows you to 
                                                            
    SCROLL,             // Done              016            Allows you to 
                                                            
    TAB,                // Done              017            Allows you to 
    TABSPACE,           // Done              018            Allows you to 
                                                            
    TREEVIEW,           // Done              019            Allows you to 
    TFOLDER,            // Done              020            Allows you to 
    TITEM,              // Done              021            Allows you to 
                                                            
    CHECKBOX,           // Done              022            Allows you to 
                                                            
    ITEM,               // Done              023            Allows you to 
    LIST,               // Done              024            Allows you to 
                                                            
    FELLOUTLIST,        // Done              025            Allows you to 
    FITEM,              // Done              026            Allows you to 
    FFOLDER,            // WIP               027            Allows you to 
    FSEPARATOR,         // WIP               028            Allows you to 
                                                            
    COLORSELECTOR,      // WIP (Almost done) 029            Allows you to 
                                                            
    CURVEEDITOR,        //                   030            Allows you to 
    TEXTFIELD,          //                   031            Allows you to 
    CODEEDITOR,         // WIP               032            Allows you to 
                                                            
    DRAGGABLE,          // Done              032            Allows you to 
                                                            
    VARTABSPACE,        // Done              033            Allows you to 
    VARTAB,             // Done              034            Allows you to 
    
    INSTFIELD,          // Done              035            Allows you to create instance fields, that allows you to store multiple values in single component like int/float and etc...
    
    TEXTURE,            // WIP               036            Allows you to see a texture
    
    TABLE,              // WIP               037            Allows you to create a table with certain data
    
    CHOOSESPACE,        // WIP               038            Allows you to create horizontal radiobutton/checkbox space with a bit cooler looking buttons
    CHOOSE,             // WIP               039            Allows you to create button parented to current choose space and it works under chooseSpace's flags
    
}
#endregion

#region Flags
enum uiFlags {                 // Supported by: | Panel | Group | Text | Sprite | Separator | Float | Int | RadioButton | Button | Scroll | Tab | Treeview | TFolder | TItem | Checkbox | Item | List | FList | FItem | FFolder | FSeparator | ColorWheel | CodeEditor | Draggable | VarTab | Choose |
                               //               |_______|_______|______|________|___________|_______|_____|_____________|________|________|_____|__________|_________|_______|__________|______|______|_______|_______|_________|____________|____________|____________|___________|________|________|
    Null                    = 1 << 0 ,       // |   +   |   +   |  +   |   +    |     +     |   +   |  +  |      +      |   +    |   +    |  +  |     +    |    +    |   +   |    +     |   +  |  +   |   +   |   +   |    +    |     +      |      +     |     +      |     +     |   +    |        |
    Fixed                   = 1 << 1 ,       // |   +   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    NonFixed                = 1 << 2 ,       // |   +   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Hor                     = 1 << 3 ,       // |   +   |   -   |  -   |   +    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Ver                     = 1 << 4 ,       // |   +   |   -   |  -   |   +    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Button                  = 1 << 5 ,       // |   -   |   -   |  +   |   +    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    TextScroll              = 1 << 6 ,       // |   -   |   -   |  +   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Right                   = 1 << 7 ,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Left                    = 1 << 8 ,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Selectable              = 1 << 9 ,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Borderless              = 1 << 10,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Full                    = 1 << 11,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Squared                 = 1 << 12,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Scrollbar               = 1 << 13,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    TOutline                = 1 << 14,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    CSCircle                = 1 << 15,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    RoundRect               = 1 << 16,       // |   -   |   -   |  -   |   +    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Top                     = 1 << 17,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Bottom                  = 1 << 18,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    CSPoint1                = 1 << 19,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    CSPoint2                = 1 << 20,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    CSPoint3                = 1 << 21,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    CSPoint4                = 1 << 22,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Fancy                   = 1 << 23,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Sprite                  = 1 << 24,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Draggable               = 1 << 25,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Inactive                = 1 << 26,       // |   -   |   +   |  +   |   +    |           |   +   |  +  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    NewLine                 = 1 << 27,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Reset                   = 1 << 28,       // |   -   |   -   |  -   |   -    |           |   +   |  +  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    AutoComplete            = 1 << 29,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    CodeHightlight          = 1 << 30,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    AutoHightlight          = 1 << 31,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    ErrorHightlight         = 1 << 32,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    LineNumbers             = 1 << 33,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    ProgressBar             = 1 << 34,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
    Gradient                = 1 << 35,       // |   -   |   -   |  -   |   -    |           |   -   |  -  |             |        |        |     |          |         |       |          |      |      |       |       |         |            |            |            |           |        |        |
                               //               |_______|_______|______|________|___________|_______|_____|_____________|________|________|_____|__________|_________|_______|__________|______|______|_______|_______|_________|____________|____________|____________|___________|________|________|
    
}
#endregion

#region Scheme
enum uiScheme {
    Background, 
    Header, 
    SliderBack, 
    Slider, 
    SliderText, 
    Text, 
    GroupBack, 
    
    InHeaderC, 
    In, 
    InSlider, 
    ClickIn, 
    
    TreeViewBack, 
    TreeViewOutL, 
    TreeViewItemSel, 
    
    Indent, 
    Indent2, 
    
    RBSize, 
    Scroll, 
    
    CSBack, 
    CSSel, 
    CSRad, 
    
    DrggblBack, 
    
    ItemBack, 
    ItemListBack, 
    
    FLBack, 
    
    ButtonBack, 
    RadioButton, 
    CBNSel, 
    CBSel, 
    
    Fancy, 
    ScrollBack, 
    TabBack, 
    FLArrowBack, 
    
    Mod2Val, 
    Inactive, 
    
    GradientAlpha, 
    
}
#endregion

#region
enum uiCode {
    Keyword, 
    Number, 
    Const, 
    Comment, 
    Word, 
    String, 
    Other, 
    Function, 
    PreProcess, 
    
    
}
#endregion

// Save ui layout on exit
// 
uiCodeHightlight = ds_map_create();
uiCodeTokens = ds_map_create();

__uiFancyQueue = ds_list_create();

__uiSchemesList = ds_list_create();
__uiSchemes = ds_map_create();
__uiSchemeID = -1;

/*#region Create default scheme
uiColorSchemeBegin("Default");
    
    uiColorSchemeSet(uiScheme.Header      , [192, 245, 0]);
    uiColorSchemeSet(uiScheme.Background  , [142, 195, 0]);
    uiColorSchemeSet(uiScheme.GroupBack   , [122, 175, 0]);
    uiColorSchemeSet(uiScheme.Slider      , [152, 205, 0]);
    uiColorSchemeSet(uiScheme.SliderBack  , [112, 165, 0]);
    uiColorSchemeSet(uiScheme.Text        , uiColor(c_white));
    uiColorSchemeSet(uiScheme.TreeViewOutL, 0);
    uiColorSchemeSet(uiScheme.InHeaderC   , -10);
    uiColorSchemeSet(uiScheme.In          , 40);
    uiColorSchemeSet(uiScheme.ClickIn     , 10);
    uiColorSchemeSet(uiScheme.InSlider    , 20);
    uiColorSchemeSet(uiScheme.TreeViewBack, [122, 175, 0]);
    
uiColorSchemeUse(uiColorSchemeEnd()); // Use it
#endregion*/

// 
uiRectangles = ds_map_create();
uiLastSize = ds_map_create();
__uiMove = false;
__uiMoveID = -1;
__uiMoveP = -1;
__uiMoveData = -1;
__uiX = 0; __uiY = 0;
__uiIN = false;
__uiMAX_WIDTH = 0; __uiMAX_HEIGHT = 0;

_Clip = shader_get_uniform(shClip, "_Clip");
_cwType = shader_get_uniform(shColorWheel, "_cwType");

global.__CLIP_RECT = -1;
global.__INST_ID   = 0;
global.__VTAB_ID   = "";
#macro SV_ClipRectangle global.__CLIP_RECT
#macro SV_InstanceID    global.__INST_ID
#macro SV_VarTabID      global.__VTAB_ID

#macro NULL 0

__uiTSFlags = -1;
__uiTSID = -1;
__uiTSSize = -1;
__uiSBID = -1;
__uiDragItem = -1;
__uiDragWidth = 100;
__uiOrientation = uiFlags.Null;

__uiClickZ = 0;

__uiMAX_WIDTH = WIDTH;

__uiTVSize = 0;
__uiTV_sh = 16;
__uiTVSelected = 0;
__uiTVSize = 0;

// Size of app surface for now
//#macro WIDTH  window_get_width()
//#macro HEIGHT window_get_height()

#region Create Semi-Dark scheme
uiColorSchemeBegin("Semi-Dark");
    
    uiColorSchemeSet(uiScheme.Header         , uiColor(c_dkgray));
    uiColorSchemeSet(uiScheme.Background     , uiColor(c_gray));
    uiColorSchemeSet(uiScheme.GroupBack      , uiColor(c_dkgray));
    uiColorSchemeSet(uiScheme.Slider         , uiColor(c_black));
    uiColorSchemeSet(uiScheme.SliderBack     , uiColor(c_dkgray));
    uiColorSchemeSet(uiScheme.Text           , uiColor(c_white));
    uiColorSchemeSet(uiScheme.TreeViewBack   , uiColor(c_ltgray));
    uiColorSchemeSet(uiScheme.Scroll         , uiColor(c_black));
    uiColorSchemeSet(uiScheme.ItemBack       , uiColor(c_dkgray));
    uiColorSchemeSet(uiScheme.ButtonBack     , uiColor(c_dkgray));
    uiColorSchemeSet(uiScheme.FLBack         , uiColor(c_dkgray));
    uiColorSchemeSet(uiScheme.RadioButton    , uiColor(c_dkgray));
    uiColorSchemeSet(uiScheme.ScrollBack     , uiColor(c_dkgray));
    uiColorSchemeSet(uiScheme.TabBack        , uiColor(c_dkgray));
    uiColorSchemeSet(uiScheme.TreeViewItemSel, c_gray);
    uiColorSchemeSet(uiScheme.CSBack         , c_ltgray);
    uiColorSchemeSet(uiScheme.CSSel          , c_dkgray);
    uiColorSchemeSet(uiScheme.DrggblBack     , c_dkgray);
    uiColorSchemeSet(uiScheme.ItemListBack   , c_dkgray);
    uiColorSchemeSet(uiScheme.CBSel          , c_ltgray);
    uiColorSchemeSet(uiScheme.CBNSel         , c_dkgray);
    uiColorSchemeSet(uiScheme.Fancy          , c_white);
    uiColorSchemeSet(uiScheme.FLArrowBack    , c_dkgray);
    uiColorSchemeSet(uiScheme.TreeViewOutL   , 0);
    uiColorSchemeSet(uiScheme.InHeaderC      , -10);
    uiColorSchemeSet(uiScheme.In             , 40);
    uiColorSchemeSet(uiScheme.ClickIn        , 10);
    uiColorSchemeSet(uiScheme.InSlider       , 20);
    uiColorSchemeSet(uiScheme.Indent         , 2);
    uiColorSchemeSet(uiScheme.Indent2        , 8);
    uiColorSchemeSet(uiScheme.Mod2Val        , 20);
    uiColorSchemeSet(uiScheme.CSRad          , 64 - 4);
    uiColorSchemeSet(uiScheme.Inactive       , 25);
    uiColorSchemeSet(uiScheme.GradientAlpha  , .5);
    
uiColorSchemeUse(uiColorSchemeEnd());
#endregion

#region Create Dark scheme
uiColorSchemeBegin("Dark");
    
    var p00  = 0;
    var p20  = merge_color(c_black, c_white, 20  / 100);
    var p40  = merge_color(c_black, c_white, 40  / 100);
    var p60  = merge_color(c_black, c_white, 60  / 100);
    var p80  = merge_color(c_black, c_white, 80  / 100);
    var p100 = merge_color(c_black, c_white, 100 / 100);
    
    // c_black  -> p20
    // c_dkgray -> p40
    // c_gray   -> p60
    // c_ltgray -> p80
    // c_white  -> p100
    
    uiColorSchemeSet(uiScheme.Header         , uiColor( p20 ));
    uiColorSchemeSet(uiScheme.Background     , uiColor( p00 ));
    uiColorSchemeSet(uiScheme.GroupBack      , uiColor( p20 ));
    uiColorSchemeSet(uiScheme.Slider         , uiColor( p40 ));
    uiColorSchemeSet(uiScheme.SliderBack     , uiColor( p20 ));
    uiColorSchemeSet(uiScheme.Text           , uiColor( p100));
    uiColorSchemeSet(uiScheme.TreeViewBack   , uiColor( p20 ));
    uiColorSchemeSet(uiScheme.Scroll         , uiColor( p60 ));
    uiColorSchemeSet(uiScheme.ItemBack       , uiColor( p20 ));
    uiColorSchemeSet(uiScheme.ButtonBack     , uiColor(-p40 ));
    uiColorSchemeSet(uiScheme.FLBack         , uiColor( p20 ));
    uiColorSchemeSet(uiScheme.RadioButton    , uiColor( p40 ));
    uiColorSchemeSet(uiScheme.ScrollBack     , uiColor( p40 ));
    uiColorSchemeSet(uiScheme.TabBack        , uiColor( p20 ));
    uiColorSchemeSet(uiScheme.TreeViewItemSel, p60   );
    uiColorSchemeSet(uiScheme.CSBack         , p60   );
    uiColorSchemeSet(uiScheme.CSSel          , p20   );
    uiColorSchemeSet(uiScheme.DrggblBack     , p20   );
    uiColorSchemeSet(uiScheme.ItemListBack   , p20   );
    uiColorSchemeSet(uiScheme.CBSel          , p60   );
    uiColorSchemeSet(uiScheme.CBNSel         , p20   );
    uiColorSchemeSet(uiScheme.Fancy          , p80   );
    uiColorSchemeSet(uiScheme.FLArrowBack    , p20   );
    uiColorSchemeSet(uiScheme.TreeViewOutL   , p60   );
    uiColorSchemeSet(uiScheme.InHeaderC      , -10   );
    uiColorSchemeSet(uiScheme.In             , 20    );
    uiColorSchemeSet(uiScheme.ClickIn        , 10    );
    uiColorSchemeSet(uiScheme.InSlider       , 20    );
    uiColorSchemeSet(uiScheme.Indent         , 2     );
    uiColorSchemeSet(uiScheme.Indent2        , 8     );
    uiColorSchemeSet(uiScheme.Mod2Val        , 10    );
    uiColorSchemeSet(uiScheme.CSRad          , 64 - 4);
    uiColorSchemeSet(uiScheme.Inactive       , -p20  );
    uiColorSchemeSet(uiScheme.GradientAlpha  , .5);
    
//uiColorSchemeUse(uiColorSchemeEnd());
#endregion

#region Code scheme
uiCodeTokens[? "struct"] = uiCode.Keyword;
uiCodeTokens[? "if"] = uiCode.Keyword;
uiCodeTokens[? "else"] = uiCode.Keyword;
uiCodeTokens[? "return"] = uiCode.Keyword;
uiCodeTokens[? "for"] = uiCode.Keyword;
uiCodeTokens[? "sampler2D"] = uiCode.Keyword;
uiCodeTokens[? "samplerCUBE"] = uiCode.Keyword;
uiCodeTokens[? "static"] = uiCode.Keyword;
uiCodeTokens[? "const"] = uiCode.Keyword;

uiCodeTokens[? "mul"] = uiCode.Function;
uiCodeTokens[? "dfdx"] = uiCode.Function;
uiCodeTokens[? "dfdy"] = uiCode.Function;
uiCodeTokens[? "transpose"] = uiCode.Function;
uiCodeTokens[? "fmod"] = uiCode.Function;
uiCodeTokens[? "modf"] = uiCode.Function;
uiCodeTokens[? "tex2D"] = uiCode.Function;
uiCodeTokens[? "texCUBE"] = uiCode.Function;
uiCodeTokens[? "abs"] = uiCode.Function;

uiCodeTokens[? "float"] = uiCode.Keyword; uiCodeTokens[? "float2"] = uiCode.Keyword;
uiCodeTokens[? "float3"] = uiCode.Keyword; uiCodeTokens[? "float4"] = uiCode.Keyword;

uiCodeTokens[? "float4x4"] = uiCode.Keyword;

uiCodeTokens[? "int"] = uiCode.Keyword; uiCodeTokens[? "int2"] = uiCode.Keyword;
uiCodeTokens[? "int3"] = uiCode.Keyword; uiCodeTokens[? "int4"] = uiCode.Keyword;

uiCodeTokens[? "SV_Position"] = uiCode.Const;
uiCodeTokens[? "SV_Target"] = uiCode.Const;

for( var i = 0; i < 10; i++ ) {
    // Const
    if( i <= 3 ) uiCodeTokens[? "SV_Target" + string(i)] = uiCode.Const;
    uiCodeTokens[? "SV_Position" + string(i)] = uiCode.Const;
    uiCodeTokens[? "SV_POSITION" + string(i)] = uiCode.Const;
    
    // Keywords
    uiCodeTokens[? "POSITION" + string(i)] = uiCode.Keyword;
    uiCodeTokens[? "NORMAL" + string(i)] = uiCode.Keyword;
    uiCodeTokens[? "TEXCOORD" + string(i)] = uiCode.Keyword;
    uiCodeTokens[? "BINORMAL" + string(i)] = uiCode.Keyword;
    uiCodeTokens[? "TANGENT" + string(i)] = uiCode.Keyword;
    uiCodeTokens[? "COLOR" + string(i)] = uiCode.Keyword;
}

// Colors
uiCodeHightlight[? uiCode.Keyword] = 14064726;
uiCodeHightlight[? uiCode.Number] = 10737592;
uiCodeHightlight[? uiCode.Const] = 11454029;
uiCodeHightlight[? uiCode.Comment] = 4825685;
uiCodeHightlight[? uiCode.Word] = 14474460;
uiCodeHightlight[? uiCode.Other] = 14474460;
uiCodeHightlight[? uiCode.String] = 6781089;
uiCodeHightlight[? uiCode.Function] = 5553311;
uiCodeHightlight[? uiCode.PreProcess] = 9868950;

// Preprocessors
uiCodePreProcess = ds_list_create();
ds_list_add(uiCodePreProcess, 
    "region", "endregion", "pragma", 
    "include"
);
#endregion

#region Code
vcode = @"struct VS {
    float4 Position : POSITION0;
    float2 Texcoord : TEXCOORD0;
};

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
};

// Get ModelViewProjection
float4x4 _MVP;

PS main(VS In) {
    PS Out;
        Out.Position = mul(_MVP, In.Position);
        Out.Texcoord = In.Texcoord;
    return Out;
}";

pcode = @"struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
};

#include '..\include\Utils.h'

#pragma region Da
sampler2D _Texture;
float2 _Time;
#pragma endregion

PS main(VS In) {
    float4 Out = tex2D(_Texture, fmod(In.Texcoord + abs(sin(_Time) / cos(_Time)) * .5, 1.));
    
    return Out;
}";
#endregion

global.__MDX = 0;
global.__MDY = 0;
global.__MLX = 0;
global.__MLY = 0;

#macro SV_MouseDeltaX global.__MDX
#macro SV_MouseDeltaY global.__MDY

#macro SV_MouseLastX global.__MLX
#macro SV_MouseLastY global.__MLY

#macro SV_SetMouse { SV_MouseLastX = __uiMX; SV_MouseLastY = __uiMY; }
#macro SV_CalcMouseDelta { SV_MouseDeltaX = (__uiMX - SV_MouseLastX); SV_MouseDeltaY = (__uiMY - SV_MouseLastY); }

__uiMX = 0;
__uiMY = 0;

