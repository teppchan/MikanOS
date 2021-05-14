#include <cstdint>
#include <cstddef>

#include "frame_buffer_config.hpp"
#include "font.hpp"
#include "graphics.hpp"

void *operator new(size_t size, void *buf)
{
    return buf;
}
void operator delete(void *obj) noexcept {}

char pixel_writer_buf[sizeof(RGBResv8BitPerColorPixelWriter)];
PixelWriter *pixel_writer;

extern "C" void KernelMain(const FrameBufferConfig &frame_buffer_config)
{
    switch (frame_buffer_config.pixel_format)
    {
    case kPixelRGBResv8BitPerColor:
        pixel_writer = new (pixel_writer_buf) RGBResv8BitPerColorPixelWriter{frame_buffer_config};
        break;
    case kPixelBGRResv8BitPerColor:
        pixel_writer = new (pixel_writer_buf) BGRResv8BitPerColorPixelWriter{frame_buffer_config};
        break;
    }
    for (int x = 0; x < frame_buffer_config.horizontal_resolution; ++x)
    {
        for (int y = 0; y < frame_buffer_config.vertical_resolution; ++y)
        {
            pixel_writer->Write(x, y, {255, 255, 255});
        }
    }
    for (int x = 0; x < 200; ++x)
    {
        for (int y = 0; y < 100; ++y)
        {
            pixel_writer->Write(100 + x, 100 + y, {0, 255, 0});
        }
    }
    for (int x = 0; x < 100; ++x)
    {
        for (int y = 0; y < 100; ++y)
        {
            pixel_writer->Write(300 + x, 120 + y, {255, 0, 0});
        }
    }

    for (int x = 0; x < 50; ++x)
    {
        for (int y = 0; y < 100; ++y)
        {
            pixel_writer->Write(450 + x, 240 + y, {0, 0, 255});
        }
    }

    WriteAscii(*pixel_writer, 50, 50, 'A', {0, 0, 0});
    WriteAscii(*pixel_writer, 58, 50, 'A', {0, 0, 0});
    WriteAscii(*pixel_writer, 58, 66, 'A', {0, 0, 0});

    while (1)
        __asm__("hlt");
}