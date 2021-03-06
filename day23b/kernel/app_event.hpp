#pragma once

#ifdef __cplusplus
extern "C"
{
#endif

    struct AppEvent
    {
        enum Type
        {
            kQuit,
            kMouseMove,
            kMouseButton,
        } type;

        union
        {
            struct
            {
                int x, y;
                int dx, dy;
                uint8_t buttons;
            } mouse_move;
            struct
            {
                int x, y;
                int press;
                int button;
            } mouse_button;
        } arg;
    };

#ifdef __cplusplus
}
#endif