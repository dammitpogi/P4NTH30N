# PROF3T/

## Responsibility
Administrative console application for the P4NTH30N system. Provides utility functions for account management, data analysis, balance testing, and MongoDB view operations. Serves as a CLI tool for maintenance and diagnostics rather than a long-running service.

## Design
- **Architecture**: Single-file console application (C# .NET 10)
- **Pattern**: Procedural with static methods - acts as a collection of admin scripts
- **Dependencies**:
  - `C0MMON` - Shared domain entities and MongoDB access
  - `Selenium.WebDriver` - Chrome browser automation
  - `MongoDB.Driver` - MongoDB view creation (N3XT view)
- **Data Storage**: Operates on MongoDB via `MongoUnitOfWork` from C0MMON
- **Configuration**: Credential files stored in `input/credentials/`

## Flow
1. **Entry**: `Main()` method in PROF3T.cs (lines 18-70)
2. **Safety Gate**: All admin commands commented out by default; uncomment single test at a time
3. **Active Operations**:
   - `AnalyzeBiggestAccounts()` - Analytics query on credentials
   - `UpdateN3XT()` - Creates MongoDB aggregation view for next-game-priority
   - `ResetGames()` - Wipes DPD and balance data (DANGEROUS)
   - `FireKirinBalanceTest()` / `OrionStarsBalanceTest()` - Balance query tests
   - `LaunchBrowser()` - Opens ChromeDriver for manual testing
4. **Data Access**: Uses `MongoUnitOfWork` from C0MMON to access `CR3D3N7IAL` collection

## Integration
- **Consumed by**: Manual execution via `dotnet run --project PROF3T/PROF3T.csproj`
- **Depends on**:
  - `C0MMON` project (MongoDB entities: Credential, Jackpot, DPD, Thresholds)
  - MongoDB database `P4NTH30N`
  - ChromeDriver in `drivers/chromedriver.exe`
- **Input**: JSON credential files in `input/credentials/`
