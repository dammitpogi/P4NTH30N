using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

namespace P4NTH30N.C0MMON;

public class Screen
{
	[DllImport("gdi32.dll", CharSet = CharSet.Auto, SetLastError = true, ExactSpelling = true)]
	private static extern int BitBlt(IntPtr hDC, int x, int y, int nWidth, int nHeight, IntPtr hSrcDC, int xSrc, int ySrc, int dwRop);

	private static readonly Bitmap ScreenPixel = new(1, 1, PixelFormat.Format32bppArgb);

	public static Color GetColorAt(Point location)
	{
		using (Graphics gdest = Graphics.FromImage(ScreenPixel))
		{
			using (Graphics gsrc = Graphics.FromHwnd(IntPtr.Zero))
			{
				IntPtr hSrcDC = gsrc.GetHdc();
				IntPtr hDC = gdest.GetHdc();
				int retval = BitBlt(hDC, 0, 0, 1, 1, hSrcDC, location.X, location.Y, (int)CopyPixelOperation.SourceCopy);
				gdest.ReleaseHdc();
				gsrc.ReleaseHdc();
			}
		}

		return ScreenPixel.GetPixel(0, 0);
	}

	public static bool WaitForColor(Point location, Color color, int timeout = 0)
	{
		int iterations = 0;
		while (GetColorAt(location).Equals(color) == false)
		{
			if (timeout.Equals(0) == false && iterations++ > timeout * 4)
				return false;
			else
				Thread.Sleep(250);
			if (GetColorAt(location).Equals(Color.FromArgb(255, 221, 221, 221)))
				throw new InvalidOperationException("Chrome Failure.");
			// Console.WriteLine($"[{iterations}] {DateTime.Now} {GetColorAt(location)}");
		}
		return true;
	}
}
