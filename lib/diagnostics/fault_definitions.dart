import 'generated_dme_fault_definitions.dart';

class FaultDefinition {
  const FaultDefinition({
    required this.title,
    required this.system,
    required this.explanation,
  });

  final String title;
  final String system;
  final String explanation;
}

const _definitions = <String, FaultDefinition>{
  '021208': FaultDefinition(
    title: 'DME coding data missing',
    system: 'Engine control / DME coding',
    explanation:
        'The DME reports that required coding data is absent. The fault does not identify why the data is missing or whether the module needs replacement.',
  ),
  '021209': FaultDefinition(
    title: 'DME coding format invalid',
    system: 'Engine control / DME coding',
    explanation:
        'The DME rejected the structure or spelling of its coding data. The code alone does not show which coding item failed.',
  ),
  '02120A': FaultDefinition(
    title: 'DME coding signature check failed',
    system: 'Engine control / DME coding',
    explanation:
        'The DME reports that a signature check on coding data did not pass. This does not establish the cause or the DME unlock state.',
  ),
  '02120B': FaultDefinition(
    title: 'DME coding VIN mismatch',
    system: 'Engine control / DME coding',
    explanation:
        'The VIN associated with DME coding does not match the value the DME expects. This may reflect a coding or module identity mismatch.',
  ),
  '02120C': FaultDefinition(
    title: 'DME coding data implausible',
    system: 'Engine control / DME coding',
    explanation:
        'The DME considers its coding data internally inconsistent or outside an expected range; the fault does not identify a specific bad parameter.',
  ),
  '024000': FaultDefinition(
    title: 'Energy saving mode active',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM reports that the vehicle is in an energy-saving mode, which can be used for transport, production, or programming. This describes an active vehicle mode; it does not by itself indicate a failed FEM or explain why the mode is active.',
  ),
  '100001': FaultDefinition(
    title: 'Throttle valve briefly sticking',
    system: 'Engine throttle control / DME',
    explanation:
        'The DME detected a short episode in which throttle-valve movement did not follow the expected command.',
  ),
  '100101': FaultDefinition(
    title: 'Throttle valve persistently sticking',
    system: 'Engine throttle control / DME',
    explanation:
        'The DME detected sustained resistance or sticking in throttle-valve movement. This fault alone does not prove the valve assembly is defective.',
  ),
  '100201': FaultDefinition(
    title: 'Throttle valve movement too slow',
    system: 'Engine throttle control / DME',
    explanation:
        'The throttle valve moved more slowly than the DME expected, suggesting resistance in the mechanism or an electrical control issue.',
  ),
  '195002': FaultDefinition(
    title: 'Tank-vent differential pressure sensor circuit shorted low',
    system: 'Fuel tank ventilation / DME',
    explanation:
        'The DME detected a short-to-ground condition in the tank-vent differential pressure sensor circuit. The fault does not by itself prove the sensor has failed.',
  ),
  '03008E': FaultDefinition(
    title: 'Front passenger window Hall sensor circuit open',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM is not receiving the expected position feedback from the front passenger window Hall sensor.',
  ),
  '03008F': FaultDefinition(
    title: 'Front passenger window Hall sensor circuit open',
    system: 'Body electronics / FEM',
    explanation:
        'A second passenger-window Hall-sensor input is reporting a broken or interrupted circuit.',
  ),
  '0300A0': FaultDefinition(
    title: 'Front passenger window needs normalization',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM has not learned a valid upper and lower position for the passenger window regulator.',
  ),
  '030343': FaultDefinition(
    title: 'Steering-column switch button stuck',
    system: 'Steering controls / SZL / FEM',
    explanation:
        'The FEM reports a stuck button input in the steering-column switch cluster (SZL), associated with the turn-signal control (FAS/BC/FLA).',
  ),
  '030350': FaultDefinition(
    title: 'Steering-column switch cluster LIN device missing',
    system: 'Body electronics / steering controls',
    explanation:
        'The FEM cannot see the expected LIN device in the steering-column switch cluster (SZL).',
  ),
  '030352': FaultDefinition(
    title: 'Steering-column LIN message counter error',
    system: 'Body electronics / steering controls',
    explanation:
        'The FEM received a steering-column switch message with an invalid alive counter, suggesting missing or inconsistent updates.',
  ),
  '030410': FaultDefinition(
    title: 'Multifunction steering-wheel LIN device missing',
    system: 'Body electronics / steering controls',
    explanation:
        'The expected LIN connection to the multifunction steering wheel was not detected by the FEM.',
  ),
  '804014': FaultDefinition(
    title: 'Terminal 30L2 supply voltage missing',
    system: 'Power distribution / FEM',
    explanation:
        'The FEM did not detect the expected supply voltage on the Terminal 30L2 circuit.',
  ),
  '80409A': FaultDefinition(
    title: 'Terminal 15N1 driver: open circuit or short to positive',
    system: 'Ignition power distribution / FEM',
    explanation:
        'The FEM detected a line interruption or short to battery positive on its KL15N1 (ignition-switched power) driver circuit. This code alone does not identify the failed component.',
  ),
  '80409B': FaultDefinition(
    title: 'Terminal 15N2 driver: open circuit or short to positive',
    system: 'Ignition power distribution / FEM',
    explanation:
        'The FEM detected a line interruption or short to battery positive on its KL15N2 (ignition-switched power) driver circuit. This code alone does not identify the failed component.',
  ),
  '80409C': FaultDefinition(
    title: 'Brake-light switch circuit fault',
    system: 'Braking controls / FEM',
    explanation:
        'The brake-light switch circuit appears open or shorted to battery voltage.',
  ),
  '8040A7': FaultDefinition(
    title: 'Rear bistable relay activation circuit shorted high',
    system: 'Power distribution / FEM',
    explanation:
        'The FEM detected an unexpectedly high voltage while commanding the rear bistable relay on Terminal 30F.',
  ),
  '8040AC': FaultDefinition(
    title: 'Rear bistable relay deactivation circuit shorted high',
    system: 'Power distribution / FEM',
    explanation:
        'The relay-control circuit remained high when the FEM attempted to switch the rear Terminal 30F relay off.',
  ),
  '8040B1': FaultDefinition(
    title: 'Intelligent battery sensor wake-up circuit fault',
    system: 'Power management / FEM',
    explanation:
        'The wake-up line to the intelligent battery sensor (IBS) is open or shorted to battery voltage.',
  ),
  // BMW SI B61 03 14 identifies this as a Terminal 30F power-management fault.
  '8040BD': FaultDefinition(
    title: 'Terminal 30F reset or deactivated',
    system: 'Power management / FEM or BDC',
    explanation:
        'The vehicle recorded a reset or shutdown of its fault-controlled Terminal 30F power supply. This can occur during power-management intervention; the code alone does not identify the cause or prove that the battery has failed.',
  ),
  '804107': FaultDefinition(
    title: 'Front interior aerial: line disconnection',
    system: 'Comfort access / FEM',
    explanation:
        'The FEM detected an open circuit on the front passenger-compartment aerial used for key detection.',
  ),
  '80415B': FaultDefinition(
    title: 'Engine-compartment lid contact circuit fault',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM sees an open or otherwise implausible signal from the engine-compartment lid contact switch.',
  ),
  '804164': FaultDefinition(
    title: 'Front passenger door contact circuit fault',
    system: 'Body electronics / FEM',
    explanation:
        'The front passenger door contact signal is shorted high or its circuit is interrupted.',
  ),
  '804166': FaultDefinition(
    title: 'Rear passenger door contact circuit fault',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM is detecting an abnormal contact signal from the passenger-side rear door.',
  ),
  '804168': FaultDefinition(
    title: 'Driver door contact circuit fault',
    system: 'Body electronics / FEM',
    explanation:
        'The driver-door contact input is shorted high or has an interrupted connection.',
  ),
  '80416A': FaultDefinition(
    title: 'Driver-side rear door contact circuit fault',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM reports an open or high-voltage condition on the driver-side rear door contact input.',
  ),
  '804183': FaultDefinition(
    title: 'Right low-beam lamp or control fault',
    system: 'Exterior lighting / FEM',
    explanation:
        'The FEM detected a failed right low-beam output or an unsuccessful lamp restart attempt.',
  ),
  '8041B6': FaultDefinition(
    title: 'Headlight beam-leveling system fault',
    system: 'Exterior lighting / headlamp leveling',
    explanation:
        'The headlamp range adjustment system has reported a fault and may not aim the beams correctly.',
  ),
  '804281': FaultDefinition(
    title: 'Windscreen wiper low-speed circuit fault',
    system: 'Wipers / FEM',
    explanation:
        'The FEM detected an open circuit or short to positive in the low-speed wiper path.',
  ),
  '804283': FaultDefinition(
    title: 'Windscreen wiper high-speed circuit fault',
    system: 'Wipers / FEM',
    explanation:
        'The high-speed wiper circuit appears open or shorted to positive.',
  ),
  '80428A': FaultDefinition(
    title: 'Front washer-pump circuit fault',
    system: 'Washer system / FEM',
    explanation:
        'The front washer pump circuit is open or shorted to battery positive.',
  ),
  '804341': FaultDefinition(
    title: 'Exterior mirror sensor circuit fault',
    system: 'Body electronics / exterior mirrors',
    explanation:
        'A mirror sensor input is open or shorted to battery positive.',
  ),
  '804343': FaultDefinition(
    title: 'Washer-jet heater circuit fault',
    system: 'Body electronics / washer system',
    explanation:
        'The heated washer-jet circuit is open or shorted to battery positive.',
  ),
  '804364': FaultDefinition(
    title: 'Refrigerant-pressure sensor circuit fault',
    system: 'Climate control / FEM',
    explanation:
        'The refrigerant-pressure sensor circuit appears open or shorted to battery positive.',
  ),
  '804365': FaultDefinition(
    title: 'Rear climate stratification circuit short to ground',
    system: 'Climate control / FEM',
    explanation:
        'The FEM detected a short to ground in the rear air-stratification control circuit.',
  ),
  '804370': FaultDefinition(
    title: 'A/C compressor control-valve circuit fault',
    system: 'Climate control / FEM',
    explanation:
        'The compressor control-valve circuit is shorted high or electrically open.',
  ),
  '804398': FaultDefinition(
    title: 'Air-recirculation sensor circuit fault',
    system: 'Climate control / air quality sensing',
    explanation:
        'The AUC air-quality sensor circuit is open or shorted to battery positive.',
  ),
  '804399': FaultDefinition(
    title: 'Air-recirculation sensor signal invalid',
    system: 'Climate control / air quality sensing',
    explanation:
        'The FEM received an implausible PWM signal from the automatic air-recirculation (AUC) sensor.',
  ),
  '8044B0': FaultDefinition(
    title: 'Steering-wheel shift-paddle circuit fault',
    system: 'Steering controls / FEM',
    explanation:
        'The shift-paddle input is shorted high or has an open circuit.',
  ),
  'CDA104': FaultDefinition(
    title: 'Road-inclination message missing at DME',
    system: 'Engine management / vehicle network',
    explanation:
        'The DME did not receive the roadway-inclination value normally supplied by the ICM or stability-control system.',
  ),
  'D90C01': FaultDefinition(
    title: 'CAS LIN master communication fault',
    system: 'Body electronics / LIN network',
    explanation:
        'The FEM is not communicating with a device on the CAS_LIN branch.',
  ),
  'D90C04': FaultDefinition(
    title: 'K-LIN_1 master communication fault',
    system: 'Body electronics / LIN network',
    explanation: 'The FEM reports no communication on the K-LIN_1 branch.',
  ),
  'D90C07': FaultDefinition(
    title: 'K-LIN_8 master communication fault',
    system: 'Body electronics / LIN network',
    explanation:
        'The FEM cannot communicate with devices on the K-LIN_8 branch.',
  ),
  'D90C0A': FaultDefinition(
    title: 'K-LIN_16 master communication fault',
    system: 'Body electronics / LIN network',
    explanation: 'The FEM has lost communication on the K-LIN_16 branch.',
  ),
  'D90C0D': FaultDefinition(
    title: 'K-LIN_E master communication fault',
    system: 'Body electronics / LIN network',
    explanation: 'Communication is missing on the FEM’s K-LIN_E branch.',
  ),
  'D90C10': FaultDefinition(
    title: 'K-LIN_F master communication fault',
    system: 'Body electronics / LIN network',
    explanation:
        'The FEM is not receiving responses from a component on K-LIN_F.',
  ),
  'D90C13': FaultDefinition(
    title: 'Headlamp LIN branch communication fault',
    system: 'Exterior lighting / LIN network',
    explanation:
        'The FEM cannot communicate over the LIN connection to the headlamp driver modules.',
  ),
  'D90D01': FaultDefinition(
    title: 'Remote-control receiver LIN device missing',
    system: 'Body electronics / keyless entry',
    explanation:
        'The FEM does not detect the expected LIN slave at remote-control receiver 1.',
  ),
  'D90D07': FaultDefinition(
    title: 'Door switch center LIN device missing',
    system: 'Body electronics / door controls',
    explanation:
        'The FEM cannot see the LIN-connected door switch center (SZT).',
  ),
  'D90D17': FaultDefinition(
    title: 'Light operating unit LIN device missing',
    system: 'Body electronics / lighting controls',
    explanation:
        'The FEM is not receiving a response from the LIN-connected light operating unit (BEL).',
  ),
  'D90D26': FaultDefinition(
    title: 'Interior mirror LIN device missing',
    system: 'Body electronics / interior mirror',
    explanation:
        'The FEM does not detect the expected LIN component in the interior rear-view mirror assembly.',
  ),
  'D90D29': FaultDefinition(
    title: 'Rain/light sensor LIN device missing',
    system: 'Body electronics / driver assistance sensors',
    explanation:
        'The FEM has lost communication with the rain, light and condensation sensor on its LIN connection.',
  ),
  'D90D2F': FaultDefinition(
    title: 'Left headlamp driver LIN device missing',
    system: 'Exterior lighting / headlamp control',
    explanation:
        'The FEM cannot communicate with the left headlamp driver module (TMS) over LIN.',
  ),
  'D90D32': FaultDefinition(
    title: 'Right headlamp driver LIN device missing',
    system: 'Exterior lighting / headlamp control',
    explanation:
        'The FEM is not receiving a LIN response from the right headlamp driver module (TMS).',
  ),
  'D90D38': FaultDefinition(
    title: 'Interior-light electronics LIN device missing',
    system: 'Body electronics / interior lighting',
    explanation:
        'The FEM has not received a response from the LIN-connected interior lighting electronics.',
  ),
  'D91573': FaultDefinition(
    title: 'DSC stabilization status message missing',
    system: 'Body electronics / stability-control network',
    explanation:
        'The FEM did not receive the DSC stabilization-status message.',
  ),
  'D91599': FaultDefinition(
    title: 'Longitudinal acceleration message missing',
    system: 'Body electronics / vehicle dynamics network',
    explanation:
        'The FEM is missing the vehicle’s center-of-gravity longitudinal acceleration message from the ICM.',
  ),
  'D9159B': FaultDefinition(
    title: 'Crash-control message missing',
    system: 'Body electronics / safety network',
    explanation:
        'The FEM did not receive the crash-control status message from the ACSM safety module.',
  ),
  'D9159F': FaultDefinition(
    title: 'Vehicle yaw-rate message missing',
    system: 'Body electronics / vehicle dynamics network',
    explanation:
        'The FEM did not receive the vehicle yaw-rate signal used by stability-related functions.',
  ),
  'D915A1': FaultDefinition(
    title: 'Vehicle-speed message missing',
    system: 'Body electronics / vehicle dynamics network',
    explanation:
        'The FEM is missing the vehicle-speed update normally sent by the ICM.',
  ),
  'D915B9': FaultDefinition(
    title: 'Engine heat-management message missing',
    system: 'Body electronics / DME communication',
    explanation:
        'The FEM did not receive the engine heat-management CAN message (0x1B9) from the DME/DDE. This records a communication timeout; it does not by itself prove a cooling-system or FEM failure. If it is intermittent or no longer active, check whether it returns and review related engine or network faults.',
  ),
  'D91654': FaultDefinition(
    title: 'Actual wheel-speed message missing',
    system: 'Body electronics / stability-control network',
    explanation:
        'The FEM did not receive the actual wheel-speed message from the DSC.',
  ),
  'D91681': FaultDefinition(
    title: 'Vehicle electrical-system voltage message missing',
    system: 'Body electronics / DME communication',
    explanation:
        'The FEM or BDC did not receive the vehicle electrical-system voltage message from the DME/DDE. This is a missing network message, not by itself proof of low voltage.',
  ),
  'D91697': FaultDefinition(
    title: 'Seat-belt and occupancy status missing',
    system: 'Body electronics / restraint system',
    explanation:
        'The FEM is missing the ACSM message containing seat-belt buckle and seat-occupancy status.',
  ),
  'D916C3': FaultDefinition(
    title: 'Emergency-call status message missing',
    system: 'Body electronics / emergency call system',
    explanation:
        'The FEM did not receive the emergency-call system status message from the telematics module.',
  ),
  'D916CA': FaultDefinition(
    title: 'Outside-temperature message missing',
    system: 'Body electronics / instrument-cluster network',
    explanation:
        'The FEM did not receive the outside-temperature message from the instrument cluster.',
  ),
  'D916ED': FaultDefinition(
    title: 'Vehicle standstill status message missing',
    system: 'Body electronics / stability-control network',
    explanation:
        'The FEM is missing the DSC message indicating whether the vehicle is stationary.',
  ),
  'D916F8': FaultDefinition(
    title: 'Time-and-date message missing',
    system: 'Body electronics / instrument-cluster network',
    explanation:
        'The FEM did not receive the time and date message from the instrument cluster.',
  ),
  'D91701': FaultDefinition(
    title: 'Driver steering-angle message missing',
    system: 'Body electronics / steering and chassis network',
    explanation:
        'The FEM did not receive the driver steering-angle value from the ICM.',
  ),
  'D91702': FaultDefinition(
    title: 'Front-axle steering-angle message missing',
    system: 'Body electronics / steering and chassis network',
    explanation:
        'The effective front-axle steering-angle message from the ICM was not received by the FEM.',
  ),
  'D91728': FaultDefinition(
    title: 'Relative-time message missing',
    system: 'Body electronics / instrument-cluster network',
    explanation:
        'The FEM did not receive the relative-time update normally transmitted by the instrument cluster.',
  ),
  'D91730': FaultDefinition(
    title: 'Odometer and range message missing',
    system: 'Engine management / instrument-cluster network',
    explanation:
        'The DME did not receive the mileage and range information sent by the instrument cluster.',
  ),
  'D91793': FaultDefinition(
    title: 'Instrument display brightness message missing',
    system: 'Body electronics / instrument-cluster network',
    explanation:
        'The FEM did not receive the LCD brightness-control message from the instrument cluster.',
  ),
  'D917A7': FaultDefinition(
    title: 'Driving-dynamics switch configuration missing',
    system: 'Body electronics / driving-mode controls',
    explanation:
        'The FEM did not receive the driving-dynamics switch configuration message.',
  ),
  'D917B3': FaultDefinition(
    title: 'Power-management load-control message missing',
    system: 'Body electronics / DME communication',
    explanation:
        'The FEM did not receive the power-management electric-load-control CAN message (0x3B3) from the DME/DDE. This records a communication timeout; it does not by itself prove a FEM, DME/DDE, or battery fault. If the code is intermittent or inactive, check whether it returns and review related power-management and network faults.',
  ),
  'D917F9': FaultDefinition(
    title: 'Drivetrain data 2 message missing',
    system: 'Body electronics / drivetrain network',
    explanation:
        'The FEM did not receive drivetrain-data message 2 (0x3F9) from the DME/DDE. A missing message does not by itself identify a failed control unit.',
  ),
  'D91CE4': FaultDefinition(
    title: 'Vehicle ride-height data missing from ICM',
    system: 'Body electronics / chassis network',
    explanation:
        'The FEM did not receive the filtered vehicle ride-height message from the chassis controller.',
  ),
  'D91CEC': FaultDefinition(
    title: 'Central-locking door status not received',
    system: 'Body electronics / central locking',
    explanation:
        'The FEM is missing a door-lock status update normally supplied by the rear electronics module.',
  ),
  'D91E42': FaultDefinition(
    title: 'Front climate status message missing',
    system: 'Body electronics / climate control',
    explanation:
        'The FEM did not receive the expected front climate-system status message from the IHKA controller.',
  ),
  'D91E46': FaultDefinition(
    title: 'Climate control panel status not received',
    system: 'Body electronics / climate control',
    explanation:
        'The FEM is missing a status update associated with the front climate control panel, sent through the IHKA system.',
  ),
  'D91EBF': FaultDefinition(
    title: 'Water-valve control message missing',
    system: 'Body electronics / climate control',
    explanation:
        'The FEM did not receive the IHKA water-valve control message expected on the vehicle network.',
  ),
  'D91EE5': FaultDefinition(
    title: 'FEM status message unavailable',
    system: 'Body electronics / vehicle network',
    explanation:
        'The FEM is reporting a missing status message. The transmitting module or message assignment can vary with vehicle equipment and software.',
  ),
  'D91F69': FaultDefinition(
    title: 'Tyre-status message timed out',
    system: 'Body electronics / chassis network',
    explanation:
        'The FEM did not receive a timely tyre-status update from the chassis controller.',
  ),
  'D91FF9': FaultDefinition(
    title: 'Drivetrain data 2 message missing (ID 230.0.2)',
    system: 'Body electronics / drivetrain network',
    explanation:
        'The FEM did not receive drivetrain-data message 2 (ID 230.0.2) from the DME/DDE. This is distinct from the 0x3F9 message reported by D917F9.',
  ),
  'CD0420': FaultDefinition(
    title: 'Gateway detected a FlexRay signalling fault',
    system: 'Central gateway / FlexRay',
    explanation:
        'The central gateway recorded a fault in FlexRay controller signalling; this can accompany loss of communication with other control units.',
  ),
  'CD0487': FaultDefinition(
    title: 'FlexRay synchronisation failed',
    system: 'Central gateway (ZGM) / FlexRay',
    explanation:
        'The central gateway could not complete FlexRay network synchronisation. This fault does not by itself identify a failed gateway or another specific module.',
  ),
  'CD1410': FaultDefinition(
    title: 'Gateway received invalid system-time data',
    system: 'Central gateway / instrument cluster network',
    explanation:
        'The ZGM rejected or flagged the system-time message sent by the instrument cluster (KOMBI).',
  ),
  '03000E': FaultDefinition(
    title: 'Driver window circuit: electrical path interrupted',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM detected a loss of electrical continuity in the driver-door power-window circuit.',
  ),
  '03000F': FaultDefinition(
    title: 'Driver window circuit: open connection detected',
    system: 'Body electronics / FEM',
    explanation:
        'The driver-side window system has an intermittent or open electrical connection reported to the FEM.',
  ),
  '030020': FaultDefinition(
    title: 'Driver window requires initialization',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM has not registered a valid learned end position for the driver-door window regulator.',
  ),
  '109001': FaultDefinition(
    title: 'Coolant temperature sensor circuit: short to positive',
    system: 'Engine cooling / temperature sensing',
    explanation:
        'The coolant-temperature sensor input is at a higher electrical level than expected, consistent with a short toward battery positive.',
  ),
  'CD9B04': FaultDefinition(
    title: 'FlexRay wheel-speed message not received',
    system: 'Vehicle network / wheel-speed data',
    explanation:
        'A controller expected an actual wheel-speed update over FlexRay but did not receive it.',
  ),
  'CD9D04': FaultDefinition(
    title: 'FlexRay longitudinal-acceleration data missing',
    system: 'Vehicle network / motion data',
    explanation:
        'The expected longitudinal acceleration message from the vehicle motion data source was absent on FlexRay.',
  ),
  'CD9E04': FaultDefinition(
    title: 'FlexRay lateral-acceleration data missing',
    system: 'Vehicle network / motion data',
    explanation:
        'A receiving controller did not get the expected lateral-acceleration information over FlexRay.',
  ),
  'CD8B04': FaultDefinition(
    title: 'FlexRay OBD diagnostics message unavailable',
    system: 'Vehicle network / diagnostics communication',
    explanation:
        'The expected OBD diagnostics message was not present on the FlexRay network.',
  ),
  'CDC004': FaultDefinition(
    title: 'A-CAN gearbox-diagnostics message missing',
    system: 'Vehicle network / transmission diagnostics',
    explanation:
        'A controller did not receive the expected gearbox diagnostic information on the A-CAN network.',
  ),
  '103008': FaultDefinition(
    title: 'Accelerator pedal sensor 1: signal below range',
    system: 'Engine management / pedal module',
    explanation:
        'Pedal position channel 1 is reporting a voltage lower than the DME expects for its operating range.',
  ),
  '103108': FaultDefinition(
    title: 'Accelerator pedal sensor 2: signal below range',
    system: 'Engine management / pedal module',
    explanation:
        'The second pedal-position channel is below its expected voltage range, so the DME may not see a plausible pedal signal.',
  ),
  '103002': FaultDefinition(
    title: 'Accelerator pedal sensor 1: signal shorted to ground',
    system: 'Engine management / pedal module',
    explanation:
        'The electrical signal for pedal-position channel 1 is being pulled toward ground.',
  ),
  '103102': FaultDefinition(
    title: 'Accelerator pedal sensor 2: signal shorted to ground',
    system: 'Engine management / pedal module',
    explanation:
        'Pedal-position channel 2 has an electrical low condition consistent with a short to ground.',
  ),
  '101401': FaultDefinition(
    title: 'Throttle valve adaptation conditions not met',
    system: 'Engine throttle control / DME',
    explanation:
        'The DME could not complete throttle-valve adaptation because the required operating conditions were not met. This code alone does not establish that the throttle valve has failed.',
  ),
  '101410': FaultDefinition(
    title: 'Throttle valve adaptation: battery voltage too low',
    system: 'Engine throttle control / DME',
    explanation:
        'The DME reports that battery voltage was too low for throttle-valve adaptation to complete. This fault alone does not establish that the throttle valve has failed.',
  ),
  'CD9933': FaultDefinition(
    title: 'FlexRay yaw-rate message not received',
    system: 'Vehicle network / FlexRay',
    explanation:
        'A vehicle controller did not receive the expected yaw-rate data message on the FlexRay network.',
  ),
  'CD9A04': FaultDefinition(
    title: 'DSC braking-torque message missing',
    system: 'Engine management / FlexRay',
    explanation:
        'The DME/DDE did not receive the expected actual total braking-torque message (43.3.4) from the DSC. The fault identifies a missing network message, not a brake-system component failure by itself.',
  ),
  'CDA004': FaultDefinition(
    title: 'FlexRay wheel-torque message unavailable',
    system: 'Vehicle network / FlexRay',
    explanation:
        'The expected drivetrain wheel-torque information was missing from the FlexRay bus.',
  ),
  'CD9904': FaultDefinition(
    title: 'FlexRay vehicle-speed message unavailable',
    system: 'Vehicle network / FlexRay',
    explanation:
        'A controller did not receive the expected vehicle-speed message over FlexRay.',
  ),
  '1B5202': FaultDefinition(
    title: 'Terminal 15N_1 supply voltage missing',
    system: 'Engine management / DME',
    explanation:
        'The DME did not detect the expected voltage on the Terminal 15N_1 circuit.',
  ),
  '1B5402': FaultDefinition(
    title: 'Terminal 15N_3 supply voltage missing',
    system: 'Engine management / DME',
    explanation:
        'The expected voltage was absent from the DME-monitored Terminal 15N_3 circuit.',
  ),
  '1BC112': FaultDefinition(
    title: 'Zero-gear sensor circuit: short to positive',
    system: 'Engine management / DME',
    explanation:
        'The DME reports an electrical fault on the zero-gear sensor circuit, consistent with the signal being shorted to battery positive (B+). This code alone does not confirm that the sensor has failed, and applicability depends on the vehicle configuration.',
  ),
  '123701': FaultDefinition(
    title: 'Wastegate position signal: short to positive',
    system: 'Turbocharger / wastegate actuator',
    explanation:
        'The electrical feedback from the wastegate position sensor appears higher than expected, consistent with a short to battery positive.',
  ),
  '121001': FaultDefinition(
    title: 'Boost pressure sensor circuit: short to positive',
    system: 'Engine air / boost pressure sensing',
    explanation:
        'The DME sees an abnormally high electrical level on the boost-pressure sensor circuit.',
  ),
  '119001': FaultDefinition(
    title: 'Rail pressure sensor circuit: short to positive',
    system: 'Fuel system / rail pressure sensing',
    explanation:
        'The rail-pressure sensor signal is registering above its expected electrical range.',
  ),
  '191004': FaultDefinition(
    title: 'Tank ventilation valve: open control circuit',
    system: 'Fuel tank ventilation / DME',
    explanation:
        'The DME detected an interrupted electrical path while controlling the tank ventilation valve.',
  ),
  '1C3110': FaultDefinition(
    title: 'Engine oil pressure/temperature sensor: electrical malfunction',
    system: 'Engine oil pressure and temperature / DME',
    explanation:
        'The DME detected an electrical fault in the engine-oil pressure/temperature sensor circuit. This code alone does not establish actual oil pressure or prove the sensor is defective.',
  ),
  '104401': FaultDefinition(
    title: 'Intake manifold pressure sensor circuit: short to positive',
    system: 'Engine air / intake pressure sensing',
    explanation:
        'The intake-manifold pressure sensor signal is being reported at an unexpectedly high electrical level.',
  ),
  '804080': FaultDefinition(
    title: 'Ignition on: startability limit reached',
    system: 'Power management / FEM',
    explanation:
        'The vehicle recorded that the ignition remained on long enough to reduce the available starting reserve.',
  ),
  '8040B9': FaultDefinition(
    title: 'Terminal 30B deactivated: startability limit reached',
    system: 'Power management / FEM',
    explanation:
        'The FEM recorded a power-management shutdown of terminal 30B because the calculated starting reserve was too low.',
  ),
  '8040BB': FaultDefinition(
    title: 'Terminal 30B active too long: startability limit reached',
    system: 'Power management / FEM',
    explanation:
        'Terminal 30B was recorded as active for too long or the vehicle reached its startability protection limit.',
  ),
  '8041B2': FaultDefinition(
    title: 'Lights active: startability limit reached',
    system: 'Lighting / FEM',
    explanation:
        'The vehicle recorded a startability-limit event while the lights were active during stationary operation.',
  ),
  '138104': FaultDefinition(
    title: 'Exhaust flap actuator: open circuit',
    system: 'Exhaust system',
    explanation:
        'The DME detected an interrupted electrical connection while commanding the exhaust flap actuator.',
  ),
};

const _n20DifferentMeanings = <String>{
  '138101',
  '138102',
  '138104',
  '1BC114',
  '1C4116',
  '1C4118',
  '1C4121',
  '1C4122',
};

FaultDefinition? faultDefinition(String code, {String? engine, String? ecu}) {
  final normalized = code.trim().toUpperCase();
  final isDme = ecu?.toUpperCase().contains('DME') ?? false;
  final family = engine?.toUpperCase();

  // These eight codes have different S55 and N20 source descriptions.
  if (isDme && family == 'N20' && _n20DifferentMeanings.contains(normalized)) {
    return n20DmeFaultDefinitions[normalized];
  }

  final curated = _definitions[normalized];
  if (curated != null) return curated;
  if (!isDme) return null;
  return switch (family) {
    'S55' => s55DmeFaultDefinitions[normalized],
    'N20' => n20DmeFaultDefinitions[normalized],
    _ => null,
  };
}
