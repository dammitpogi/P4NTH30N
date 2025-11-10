using System.Drawing;
using System.Runtime.InteropServices;

namespace P4NTH30N.C0MMON;

public class Mouse {
	private static readonly Random random = new();
	private static readonly int mouseSpeed = 15;

	public static void Click(int x, int y) {
		MoveMouse(x, y, 0, 0);
		SetCursorPos(x, y);
		mouse_event(LMBDown, x, y, 0, 0);
		mouse_event(LMBUp, x, y, 0, 0);
	}

	public static void Move(int x, int y) {
		MoveMouse(x, y, 0, 0);
		SetCursorPos(x, y);
	}

	public static void LongClick(int x, int y) {
		MoveMouse(x, y, 0, 0);
		SetCursorPos(x, y);
		mouse_event(LMBDown, x, y, 0, 0);
		Thread.Sleep(5000);
		mouse_event(LMBUp, x, y, 0, 0);
	}

	public static void RtClick(int x, int y) {
		MoveMouse(x, y, 0, 0);
		SetCursorPos(x, y);
		mouse_event(RMBDown, x, y, 0, 0);
		mouse_event(RMBUp, x, y, 0, 0);
	}

	private static void MoveMouse(int x, int y, int rx, int ry) {
		Point c = new();
		GetCursorPos(out c);

		x += random.Next(rx);
		y += random.Next(ry);

		double randomSpeed = Math.Max((random.Next(mouseSpeed) / 2.0 + mouseSpeed) / 10.0, 0.1);

		WindMouse(
			c.X,
			c.Y,
			x,
			y,
			9.0,
			3.0,
			10.0 / randomSpeed,
			15.0 / randomSpeed,
			10.0 * randomSpeed,
			10.0 * randomSpeed
		);
	}

	private static void WindMouse(
		double xs,
		double ys,
		double xe,
		double ye,
		double gravity,
		double wind,
		double minWait,
		double maxWait,
		double maxStep,
		double targetArea
	) {
		double dist,
			windX = 0,
			windY = 0,
			veloX = 0,
			veloY = 0,
			randomDist,
			veloMag,
			step;
		int oldX,
			oldY,
			newX = (int)Math.Round(xs),
			newY = (int)Math.Round(ys);

		double waitDiff = maxWait - minWait;
		double sqrt2 = Math.Sqrt(2.0);
		double sqrt3 = Math.Sqrt(3.0);
		double sqrt5 = Math.Sqrt(5.0);

		dist = Hypot(xe - xs, ye - ys);

		while (dist > 1.0) {
			wind = Math.Min(wind, dist);

			if (dist >= targetArea) {
				int w = random.Next((int)Math.Round(wind) * 2 + 1);
				windX = windX / sqrt3 + (w - wind) / sqrt5;
				windY = windY / sqrt3 + (w - wind) / sqrt5;
			} else {
				windX /= sqrt2;
				windY /= sqrt2;
				if (maxStep < 3)
					maxStep = random.Next(3) + 3.0;
				else
					maxStep /= sqrt5;
			}

			veloX += windX;
			veloY += windY;
			veloX += gravity * (xe - xs) / dist;
			veloY += gravity * (ye - ys) / dist;

			if (Hypot(veloX, veloY) > maxStep) {
				randomDist = maxStep / 2.0 + random.Next((int)Math.Round(maxStep) / 2);
				veloMag = Hypot(veloX, veloY);
				veloX = veloX / veloMag * randomDist;
				veloY = veloY / veloMag * randomDist;
			}

			oldX = (int)Math.Round(xs);
			oldY = (int)Math.Round(ys);
			xs += veloX;
			ys += veloY;
			dist = Hypot(xe - xs, ye - ys);
			newX = (int)Math.Round(xs);
			newY = (int)Math.Round(ys);

			if (oldX != newX || oldY != newY)
				SetCursorPos(newX, newY);

			step = Hypot(xs - oldX, ys - oldY);
			int wait = (int)Math.Round(waitDiff * (step / maxStep) + minWait);
			Thread.Sleep(wait);
		}

		int endX = (int)Math.Round(xe);
		int endY = (int)Math.Round(ye);
		if (endX != newX || endY != newY)
			SetCursorPos(endX, endY);
	}

	private static double Hypot(double dx, double dy) {
		return Math.Sqrt(dx * dx + dy * dy);
	}

	[DllImport("user32.dll")]
	private static extern bool GetCursorPos(out Point p);

	[DllImport("user32.dll")]
	private static extern bool SetCursorPos(int X, int Y);

	[DllImport("user32.dll")]
	private static extern void mouse_event(
		int dwFlags,
		int dx,
		int dy,
		int cButtons,
		int dwExtraInfo
	);

	private const int LMBDown = 0x02,
		LMBUp = 0x04,
		RMBDown = 0x08,
		RMBUp = 0x10;
}
