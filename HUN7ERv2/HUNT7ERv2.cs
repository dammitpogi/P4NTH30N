using Figgle;
using P4NTH30N.C0MMON;

namespace P4NTH30N {
    [GenerateFiggleText(sourceText: "v    0 . 2 . 0 . 0", memberName: "Version", fontName: "colossal")]
    internal static partial class Header { }
}

internal class Program {
    private static void Main(string[] args) {
        _ = args;

        while (true) {
            try {


                List<CredentialRecord> credentials = CredentialRecord.GetAll();
                foreach (CredentialRecord credential in credentials) {
                    bool updated = false;

                    if (credential.Balance < 1 && credential.Toggles.CashedOut.Equals(false)) {
                        credential.Toggles.CashedOut = true; updated = true;
                    } else if (credential.Balance > 3 && credential.Toggles.CashedOut) {
                        credential.Dates.LastDepositDate = DateTime.UtcNow;
                        credential.Toggles.CashedOut = false;
                        updated = true;
                    }

                    if (credential.Toggles.Unlocked == false && DateTime.UtcNow > credential.Dates.UnlockTimeout) {
                        credential.Toggles.Unlocked = true; updated = false;
                    }

                    if (updated) credential.Save();
                }

                
            } catch (Exception ex) {
                Console.WriteLine(ex.Message);
            }
        }
    }
}
