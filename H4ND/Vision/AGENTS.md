# Vision

## Responsibility

Vision provides FourEyes integration, command handling, and execution tracking for H4ND. It coordinates between automation signals and visual command processing, ensuring proper execution tracking and command validation within the Vision system.

## When Working Here

- **FourEyes integration**: Command processing and validation
- **Command handling**: Vision command parsing and execution
- **Execution tracking**: Spin execution progress and result tracking
- **Event coordination**: Command event publishing and monitoring
- **Signal integration**: Signal-to-VisionCommand mapping and processing
- **Visual validation**: Visual state verification and confirmation

## Core Functions

- **Vision Command Handling**: Parse, validate, and execute Vision commands
- **FourEyes Integration**: Coordinate with FourEyes system for command validation
- **Execution Tracking**: Track spin execution progress and results
- **Command Publishing**: Publish commands to event bus for execution
- **Signal Integration**: Map signals to Vision commands for processing
- **Visual Confirmation**: Visual state verification and execution confirmation

## Main Processing Loop

```
Initialize Vision System
├── Load Configuration (Vision, Commands, FourEyes)
├── Connect to MongoDB (Events, Commands, Signals)
├── Initialize Vision Command Handler
├── Setup Command Publisher
├── Initialize Execution Tracker
├── Connect to FourEyes System
└── Vision Operations Loop
    ├── Command Processing
    │   ├── Receive Vision commands
    │   ├── Validate command structure
    │   ├── Parse command parameters
    │   └── Queue for execution
    ├── FourEyes Integration
    │   ├── Send commands to FourEyes
    │   ├── Process FourEyes responses
    │   ├── Validate command execution
    │   └── Handle integration errors
    ├── Execution Tracking
    │   ├── Track command progress
    │   ├── Monitor execution status
    │   ├── Collect execution results
    │   └── Log execution events
    ├── Signal Integration
    │   ├── Map signals to Vision commands
    │   ├── Prioritize command execution
    │   ├── Handle signal failures
    │   └── Report signal completion
    └── Event Coordination
        ├── Publish to event bus
        ├── Subscribe to command events
        ├── Process event responses
        └── Handle event errors
```

## Key Patterns

1. **Command Processing Pipeline**: Command validation, parsing, and execution pipeline
2. **FourEyes Integration Pattern**: Command validation and response handling
3. **Execution Tracking**: Real-time progress monitoring and result collection
4. **Signal-to-Command Mapping**: Priority-based signal to Vision command conversion
5. **Event-Driven Architecture**: Command processing via event bus messages
6. **Visual Confirmation**: Visual state verification before and after execution
7. **Command Validation**: Multi-level validation with error handling

## Dependencies

**From C0MMON:**
- `MongoUnitOfWork`: Database operations for events and commands
- `VisionCommand` entity: FourEyes command structure and validation
- `Signal` entity: Signal-to-VisionCommand mapping data
- `Infrastructure/EventBus`: In-memory event bus for command processing
- `Monitoring/ErrorLog`: Error logging and validation tracking

**Vision Infrastructure:**
- `VisionCommandHandler`: Vision command parsing and validation
- `VisionCommandPublisher`: Command publishing to event bus
- `VisionExecutionTracker`: Execution progress and result tracking
- `FourEyesCommandValidator`: Command validation with FourEyes
- `VisionCommandMapper`: Signal-to-VisionCommand mapping
- `VisionEventProcessor`: Event processing and response handling

**External:**
- System.Text.Json: Command serialization and deserialization
- Microsoft.Extensions.Logging: Vision-specific logging
- Chrome DevTools Protocol: Visual state verification
- FourEyes API: External command validation system

## Data Collections

- **V1S10N**: Vision command processing events and data
- **CMD3**: Command validation and execution records
- **TR4CK**: Execution tracking and progress data
- **F0UREY3S**: FourEyes integration and validation data
- **S1GN4L**: Signal-to-command mapping and processing data

## Platform Support

- **Windows**: Primary deployment with .NET runtime support
- **Cross-platform**: Vision logic designed for cross-platform compatibility
- **HTTP/REST**: FourEyes integration via HTTP endpoints
- **WebSocket**: Real-time event bus communication

## Recent Updates (2026-02-23)

### Vision Architecture Enhancement
- FourEyes integration with command validation
- Enhanced command processing and execution tracking
- Signal-to-VisionCommand mapping and priority handling
- Real-time execution progress monitoring

### New Vision Components (2026-02-20)
- **VisionCommandHandler.cs**: Vision command parsing and validation
- **VisionCommandPublisher.cs**: Command publishing to event bus
- **VisionExecutionTracker.cs**: Execution progress and result tracking
- **FourEyesCommandValidator.cs**: Command validation with FourEyes
- **VisionCommandMapper.cs**: Signal-to-VisionCommand mapping
- **VisionEventProcessor.cs**: Event processing and response handling

### Recent Modifications (2026-02-23)
- **VisionCommandHandler.cs**: Enhanced command validation and error handling
- **VisionExecutionTracker.cs**: Improved execution progress tracking
- **VisionCommandPublisher.cs**: Refined event bus integration
- **FourEyesCommandValidator.cs**: Extended validation rules and response handling

---

*Template Usage:*
- Replace `{{PLACEHOLDER}}` values with directory-specific content
- Maintain consistent 2-space indentation
- Use ASCII diagrams where appropriate
- Follow existing documentation style