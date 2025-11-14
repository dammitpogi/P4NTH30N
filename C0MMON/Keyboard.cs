using System;
using WindowsInput;

namespace P4NTH30N.C0MMON;

public class Keyboard {
	public static Keyboard Send(string text) {
		new InputSimulator().Keyboard.TextEntry(text);
		Thread.Sleep(400);
		return new Keyboard();
	}

	public static Keyboard WindowsManager() {
		new InputSimulator().Keyboard.ModifiedKeyStroke(
			[VirtualKeyCode.CONTROL, VirtualKeyCode.SHIFT],
			VirtualKeyCode.VK_D
		);
		Thread.Sleep(400);
		return new Keyboard();
	}

    public static Keyboard AltTab() {
		new InputSimulator().Keyboard.ModifiedKeyStroke(
			[VirtualKeyCode.LMENU], VirtualKeyCode.TAB
		);
		Thread.Sleep(400);
		return new Keyboard();
	}

    public static Keyboard DevTools() {
		new InputSimulator().Keyboard.ModifiedKeyStroke(
			[VirtualKeyCode.LCONTROL, VirtualKeyCode.LSHIFT], VirtualKeyCode.VK_I
		);
		Thread.Sleep(400);
		return new Keyboard();
	}
    public static Keyboard Screenshot() {
        new InputSimulator().Keyboard.ModifiedKeyStroke(
            [VirtualKeyCode.LWIN],
            VirtualKeyCode.SNAPSHOT
        );
        return new Keyboard();
    }

	public static Keyboard PressEnter() {
		new InputSimulator().Keyboard.KeyPress(VirtualKeyCode.RETURN);
		Thread.Sleep(400);
		return new Keyboard();
	}

	public static Keyboard PressPageDown() {
		new InputSimulator().Keyboard.KeyPress(VirtualKeyCode.NEXT);
		Thread.Sleep(400);
		return new Keyboard();
	}

	public Keyboard Wait(int ms) {
		Thread.Sleep(ms);
		return new Keyboard();
	}

	public Keyboard Enter() {
		new InputSimulator().Keyboard.KeyPress(VirtualKeyCode.RETURN);
		Thread.Sleep(400);
		return new Keyboard();
	}

	public Keyboard PageDown() {
		new InputSimulator().Keyboard.KeyPress(VirtualKeyCode.NEXT);
		Thread.Sleep(400);
		return new Keyboard();
	}
}
