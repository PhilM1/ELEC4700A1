%Assignment 1 for ELEC 4700 - Philippe Masson

timestep = 1e-14; %10fs
region_size_x = 200e-9; %meter
region_size_y = 100e-9; %meter
numParticles = 10000;
simLength = 1000; %number of iterations of the simulation
temperature = 300; %Kelvin
mass_electron = 9.10938356e-31; %electron rest mass [kg]
mass_effective = 0.26*mass_electron; %electron effective mass [kg]
const_boltzman = 1.38064852e-23; %Boltzman constant [m^2 kg / s^2 K]
velocity_thermal = sqrt(const_boltzman*temperature/mass_effective); %thermal velocity
collisionTime = 0.2e-12; %time between particle collisions

%particle array is in following format: 
%xPos, yPos, Velocity Mag, xDir(norm), yDir(norm), TimeSinceLastScatter
particleArray = [];

tempArrary = []; %array to store temperature history
particleXPos7Array = []; %array to store 7 X positions history
particleYPos7Array = []; %array to store 7 Y positions history
scatterTimeArray = []; %array to store the time between scatters

scatterProbability = 1 - exp(-timestep/collisionTime); %probability of particle being scattered

%change both of these to 0 if you want part 1 plots
Part2 = 1; %change this to 1 & Part3 to 0 if you want part 2 plots
Part3 = 0; %change this to 1 if you want part 3 plots

%initialize the particles
for i = 1:numParticles
    %init positions
    particleArray(i,1) = rand * region_size_x;
    particleArray(i,2) = rand * region_size_y;
    
    if(Part2 == 1 || Part3 == 1)
        vth = randn*velocity_thermal + velocity_thermal;
    else
        vth = velocity_thermal;
    end
    %init velocity
    particleArray(i,3) = vth; %velocity magnitude
    particleArray(i,4) = (rand * 2) - 1; %x-direction (normalized)
    particleArray(i,5) = sqrt(1-particleArray(i,4)^2); %y-direction (normalized)
    if(rand > 0.5)
        particleArray(i,5) = particleArray(i,5) * -1;
    end
    
    particleArray(i,6) = 0; %set time since last scatter to 0
        
end

%plot histogram of velocities
figure(1);
histogram(particleArray(:,3));
title(['Histogram of Initial Velocity Distribution, Mean = ' num2str(mean(particleArray(:,3)))]);
xlabel('Thermal Velocity of a Given Particle (m/s)');
ylabel('Counts');

for simCount = 1:simLength
    currTime = simCount * timestep;
        
    %scatter particles
    for i = 1:numParticles
        %update time since last scatter
        particleArray(i,6) = particleArray(i,6) + timestep;
        
        if(rand <= scatterProbability) %scatter the particle
            particleArray(i,3) = randn*velocity_thermal + velocity_thermal; %randomize velocity
            particleArray(i,4) = (rand * 2) - 1; %x-direction (normalized)
            particleArray(i,5) = sqrt(1-particleArray(i,4)^2); %y-direction (normalized)
            if(rand > 0.5)
                particleArray(i,5) = particleArray(i,5) * -1;
            end
            %store time between scatters
            particleArray(i,6) = 0; %reset time since last scatter
        end
    end
    
    %update particle positions
    new_xPos = particleArray(:,1) + timestep * particleArray(:,3) .* particleArray(:,4);
    new_yPos = particleArray(:,2) + timestep * particleArray(:,3) .* particleArray(:,5);
    
    
    
    %check boundary conditions
    for i = 1:numParticles
        if(new_xPos(i) < 0) %bounce off boundary
            new_xPos(i) = abs(new_xPos(i) - particleArray(i,1));
            particleArray(i,4) = particleArray(i,4) * -1; %swap direction
        elseif(new_xPos(i) > region_size_x) %bounce off boundary
            new_xPos(i) = region_size_x - abs(new_xPos(i) - particleArray(i,1));
            particleArray(i,4) = particleArray(i,4) * -1; %swap direction
        end
        
        if(new_yPos(i) < 0) %bounce off boundary
            new_yPos(i) = abs(new_yPos(i) - particleArray(i,2));
            particleArray(i,5) = particleArray(i,5) * -1; %swap direction
        elseif(new_yPos(i) > region_size_y) %bounce off boundary
            new_yPos(i) = region_size_y - abs(new_yPos(i) - particleArray(i,2));
            particleArray(i,5) = particleArray(i,5) * -1; %swap direction
        end
    end
    
%     figure(2);
%     hold on;
%     plot([particleArray(1,1), new_xPos(1)],[particleArray(1,2), new_yPos(1)]);
%     plot([particleArray(2,1), new_xPos(2)],[particleArray(2,2), new_yPos(2)]);
%     plot([particleArray(3,1), new_xPos(3)],[particleArray(3,2), new_yPos(3)]);
%     plot([particleArray(4,1), new_xPos(4)],[particleArray(4,2), new_yPos(4)]);
%     plot([particleArray(5,1), new_xPos(5)],[particleArray(5,2), new_yPos(5)]);
%     plot([particleArray(6,1), new_xPos(6)],[particleArray(6,2), new_yPos(6)]);
%     plot([particleArray(7,1), new_xPos(7)],[particleArray(7,2), new_yPos(7)]);
%     xlim([0,region_size_x]);
%     ylim([0,region_size_y]);
%     title(['Particle Trajectory, Simulation Count: ', num2str(simCount), ', Timestep: ', num2str(timestep)]);
%     xlabel('X (m)');
%     ylabel('Y (m)');
%     hold off;
    
    particleArray(:,1) = new_xPos;
    particleArray(:,2) = new_yPos;
    
    %Scatter plotting of the particles
%     figure(4);
%     scatter(particleArray(:,1), particleArray(:,2), 5);
%     axis([0, region_size_x, 0, region_size_y]);
%     title(['Scatter Plot of Particles in a box. Iteration: ', num2str(simCount)]);
%     xlabel('X (m)');
%     ylabel('Y (m)');

    %save the particle position history to be plotted later
     particleXPos7Array(1:7,simCount) = particleArray(1:7,1);
     particleYPos7Array(1:7,simCount) = particleArray(1:7,2);

    %save the temperature history to be plotted later
    tempArray(simCount) = mean(particleArray(:,3))^2*mass_effective/const_boltzman;


    %pause(0.0001); %quick pause so that the graphs can be displayed live
    if(mod(simCount,100) == 0) %Update the console with current simCount
        disp(['simcount: ', num2str(simCount), ' of ', num2str(simLength)]);
    end
end


%plot the trajectory of the particles
figure(10);
hold on;
for i = 1:7
    plot(particleXPos7Array(i,:),particleYPos7Array(i,:));
end
xlim([0,region_size_x]);
ylim([0,region_size_y]);
title(['Particle Trajectory, Simulation Count: ', num2str(simCount), ', Timestep: ', num2str(timestep)]);
xlabel('X (m)');
ylabel('Y (m)');

%plot the temperature over time
figure(11);
x = linspace(timestep,simLength*timestep,simLength);
plot(x,tempArray);
title('Average Temperature Over Time');
xlabel('Time (s)');
ylabel('Temperature (K)');